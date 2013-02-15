#!/usr/bin/env python
'''
create_bz2.py

Copyright 2013 Andres Riancho

This file is part of w3af, http://w3af.org/ .

w3af is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation version 2 of the License.

w3af is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with w3af; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
'''
import argparse
import subprocess
import shlex
import sys
import os

from datetime import date

try:
    from blessings import Terminal
    from hurry.filesize import size
except ImportError:
    print 'Missing dependencies, please run:'
    print 'sudo pip install -r requirements.txt'

term = Terminal()

def red(text):
    print term.red(text)

def yellow(text):
    print term.yellow(text)

def green(text, newline=True):
    if newline:
        print term.green(text)
    else:
        print term.green(text),

def bold(text, newline=True):
    if newline:
        print term.bold(text)
    else:
        print term.bold(text),

def parse_args():
    parser = argparse.ArgumentParser(description='Build a source package for w3af.')
    parser.add_argument('--w3af-path', dest='w3af_path', action='store',
                        help='The path to w3af\'s GIT repository.')
    parser.add_argument('--release-version', dest='release_version', action='store',
                        help='The release version to use for this package.')
    parser.add_argument('--no-git', dest='git', action='store_true',
                        help='Do not run any git related commands.')

    args = parser.parse_args()

    if args.w3af_path is None or args.release_version is None:
        bold('Both --w3af-path and --release-version are required.')
        sys.exit(-1)

    return args

class FakeProcess(object):
    returncode = 0

def method_check_output(cmd):
    try:
        output = subprocess.check_output(cmd, shell=True)
    except subprocess.CalledProcessError:
        red('Error (retcode was not 0)')
        return False
    else:
        stdout, stderr = output, ''
        p = FakeProcess()

    return p, stdout, stderr

def method_popen(cmd):
    cmd_args = shlex.split(cmd)
    p = subprocess.Popen(cmd_args, stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE)
    stdout, stderr = p.communicate()

    return p, stdout, stderr

def method_system(cmd):
    returncode = os.system(cmd)

    p = FakeProcess()
    p.returncode = returncode

    return p, '', ''

def run_debug(cmd, output_success=None, output_error=None, method='popen'):
    green('Running:', newline=False)
    print('"%s"' % cmd)

    METHODS = {
               'check_output': method_check_output,
               'popen': method_popen,
               'system': method_system,
              }

    p, stdout, stderr = METHODS[method](cmd)

    if stdout: print stdout
    if stderr: print stderr

    if output_success is not None:
        success = output_success in stdout
        #green('Success (found: %s)' % output_success)
        return True

    if output_error is not None:
        if output_error in stdout or output_error in stderr:
            red('Error (found: "%s")' % output_error)
            return False

    if p.returncode == 0:
        #green('Success (retcode: %s)' % p.returncode)
        return True
    else:
        red('Error (retcode: %s)' % p.returncode)
        return False

def run_all(*args):
    for function_ptr, args, kwds in args:
        result = function_ptr(*args, **kwds)
        if not result:
            return False

    return True

def verify_w3af_path(args):
    '''
    Make sure that the user provided directory has all the files we require
    '''
    for filename in ['w3af_console', 'w3af_gui', 'core', '/readme/CHANGELOG',
                     '/core/data/constants/version.txt', '.git']:
        if not os.path.exists('%s/%s' %(args.w3af_path, filename)):
            red('Missing file %s in %s' % (filename, args.w3af_path))
            return False

    green('Verified environment')
    return True

def remove_external_files(args):
    # remove the compiled python modules
    result = run_debug('find -L %s -name "*.pyc" 2>/dev/null | xargs rm -rf' % args.w3af_path,
                       method='check_output')
    if not result: return False

    # remove the backup files
    result = run_debug('find -L %s -name "*~" 2>/dev/null | xargs rm -rf' % args.w3af_path,
                       method='check_output')
    if not result: return False

    # remove the svn stuff
    #   AR:
    #       Since we're going to be shipping an "Auto-Update feature" based on SVN in the near future,
    #       I think that it's smart to keep the SVN metadata in the package. It won't hurt much in the
    #       package size since the metadata holds the same information as the file and that should be
    #       handled by tar.
    #find -L ../../w3af -name .svn | xargs rm -rf

    # remove some paths and files that are created during the run
    for filename in ['output*.*', '.noseids', '.coverage', 'nose.cfg']:
        result = run_debug('rm -rf %s/%s' % (args.w3af_path, filename))
        if not result:
            return False

    return True

def create_release_branch(args):
    '''
    # download the newly created tag
    cd ../../tags/
    svn up

    # now we copy the tag to a temp directory
    cd ../extras/pkg-generation/

    # copy the tag so we don't destroy our local copy
    cp -Rp ../../tags/$1/ ../../w3af

    # change the SVN URL for the tag to the trunk so we properly update the user's installation
    cd ../../w3af
    svn switch https://w3af.svn.sourceforge.net/svnroot/w3af/trunk
    cd -
    '''
    return True

def set_release_version(args):
    version_file = '%s/core/data/constants/version.txt' % args.w3af_path
    file(version_file, 'w').write(args.release_version)
    green('Bumped version.txt to ', newline=False)
    bold(args.release_version)

    return True

def update_changelog(args):
    changelog_fmt = '''%(date)s    Version %(version)s
    ======================================
    Github tag: https://github.com/andresriancho/w3af/tree/%(version)s
    Github milestone: https://github.com/andresriancho/w3af/issues?milestone=%(milestone)s

        * Added A
        * Added B
        * Fixed C
    
    '''
    msg = 'Enter the milestone id for this release'\
          ' (/andresriancho/w3af/issues?milestone=%s):'
    bold(msg, newline=False)
    milestone = raw_input()
    milestone = milestone.strip()

    if not milestone.isdigit():
        red('The milestone needs to be a digit.')
        return False

    today = date.today()

    data = {
            'date': today.strftime("%A %d %B %Y"),
            'version': args.release_version,
            'milestone': milestone,
           }
    changelog_entry = changelog_fmt % data
    changelog_entry = changelog_entry.replace('\n    ', '\n')
    changelog_file = '%s/readme/CHANGELOG' % args.w3af_path

    old_changelog = file(changelog_file).read()
    file(changelog_file, 'w').write(changelog_entry + old_changelog)
    run_debug('joe %s' % changelog_file, method='system')

    return True

def run_sphinx(args):
    return True

def split_w3af_path(user_provided_path):
    full_path = user_provided_path
    if not full_path.endswith('/'): full_path += '/'

    parent = os.sep.join(full_path.split(os.sep)[:-2])
    w3af = full_path.split(os.sep)[-2]

    return parent, w3af

def create_bz2(args):
    yellow('Removing previous builds from the working directory')

    run_debug('rm -rf w3af-%s.tar' % args.release_version)
    run_debug('rm -rf w3af-%s.tar.bz2' % args.release_version)

    bold('Creating bz2 archive, this might take some time...')

    parent, w3af = split_w3af_path(args.w3af_path)

    run_debug('tar -chpf w3af-%s.tar -C %s %s' % (args.release_version, parent, w3af))
    run_debug('pbzip2 -9 w3af-%s.tar' % (args.release_version,))

    green("File created!")

    fname = 'w3af-%s.tar.bz2' % args.release_version
    fsize = size(os.path.getsize(fname))
    bold('%s file size is %s' % (fname, fsize,))

    run_debug('md5sum w3af-%s.tar.bz2  > w3af-%s.tar.bz2.md5sum' % (args.release_version,
                                                                    args.release_version),
                                                                    method='system')

    return True

def unittest_bz2(args):
    '''
    Take the generated bz2, uncompress it and run some tests over it.
    '''
    bold('Unittesting generated package')

    fname = 'w3af-%s.tar.bz2' % args.release_version
    target_path = '/tmp'

    yellow('Removing any old unittest files')
    run_debug('rm -rf %s/w3af-%s.tar' %(target_path, args.release_version))
    parent, w3af = split_w3af_path(args.w3af_path)
    run_debug('rm -rf %s/%s' %(target_path, w3af))

    bold('Copy and extract generated package')
    run_debug('cp %s %s' %(fname, target_path))
    run_debug('bunzip2 %s/%s' % (target_path, fname))
    run_debug('tar -xpf %s/w3af-%s.tar -C %s' % (target_path, args.release_version,
                                                 target_path))

    current_wd = os.getcwd()
    os.chdir('%s/w3af/' % target_path)

    run_debug('ls --color')
    bold('Does the tar content look file to you? [Y/n]', newline=False)
    cc = content_correct = raw_input()

    if not(cc.lower() == 'y' or cc.lower() == 'yes' or cc == ''):
        red('The tar content is incorrect.')
        return False

    bold('Running unittests')

    nose_tests = [
                 # '-a smoke plugins/',
                  'core/controllers/tests/',
                  'core/data/'
                 ]

    for nose_params in nose_tests:
        result = run_debug('nosetests %s' % nose_params)
        if not result:
            red('Unittest failed!')
            os.chdir(current_wd)
            return False

    os.chdir(current_wd)

    return True

def upload_files_to_site(args):
    bold('Do you want to upload the files to w3af.org? [Y/n]', newline=False)
    upload = raw_input()
    upload = upload.strip()

    if upload.lower() == 'y' or upload.lower() == 'yes' or upload == '':
        path = '/var/www/w3af.org/webroot/wp-content/uploads/'

        run_debug('scp w3af-%s.tar.bz2 ubuntu@w3af.org:%s' % (args.release_version,
                                                              path))
        run_debug('scp w3af-%s.tar.bz2.md5sum ubuntu@w3af.org:%s' % (args.release_version,
                                                                     path))

        green('Uploaded files to w3af.org!')
        bold('Remember to add links to these files from wordpress.')

    return True

def git_flow_release(args):
    '''
    # Cleanup
    rm -rf ../../w3af
    '''
    return True

if __name__ == '__main__':
    args = parse_args()

    # See: https://github.com/andresriancho/w3af/wiki/Creating-a-source-package
    result = run_all(
        (verify_w3af_path, (args,), {}),
        (remove_external_files, (args,), {}),
        (create_release_branch, (args,), {}),
        (set_release_version, (args,), {}),
        (update_changelog, (args,), {}),
        (run_sphinx, (args,), {}),
        (create_bz2, (args,), {}),
        (unittest_bz2, (args,), {}),
        (upload_files_to_site, (args,), {}),
        (git_flow_release, (args,), {}),
    )

    if result:
        green('Finished creating the new w3af package. Next steps are here:')
        green('https://github.com/andresriancho/w3af/wiki/Creating-a-source-package')
    else:
        red('Package generation failed!')



