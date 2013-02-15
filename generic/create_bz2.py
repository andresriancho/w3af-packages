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

from datetime import date

from blessings import Terminal

term = Terminal()

def red(text):
    print term.red(text)

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

def run_debug(cmd, output_success=None, output_error=None, pipe=False):
    green('Running:', newline=False)
    print('"%s"' % cmd)

    if pipe:
        try:
            output = subprocess.check_output(cmd, shell=True)
        except subprocess.CalledProcessError:
            red('Error (retcode was not 0)')
            return False
        else:
            stdout, stderr = output, ''
            class Process(object):
                returncode = 0
            p = Process()
    else:
        cmd_args = shlex.split(cmd)
        p = subprocess.Popen(cmd_args, stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE)
        stdout, stderr = p.communicate()

    if stdout: print stdout
    if stderr: print stderr

    if output_success is not None:
        success = output_success in stdout
        green('Success (found: %s)' % output_success)
        return True

    if output_error is not None:
        if output_error in stdout or output_error in stderr:
            red('Error (found: "%s")' % output_error)
            return False

    if p.returncode == 0:
        green('Success (retcode: %s)' % p.returncode)
        return True
    else:
        red('Error (retcode: %s)' % p.returncode)
        return False

def run_all(*args):
    for function_ptr, args, kwds in args:
        result = function_ptr(*args, **kwds)
        if not result:
            break

def remove_external_files(args):
    # remove the compiled python modules
    result = run_debug('find -L %s -name "*.pyc" 2>/dev/null | xargs rm -rf' % args.w3af_path, pipe=True)
    if not result: return False

    # remove the backup files
    result = run_debug('find -L %s -name "*~" 2>/dev/null | xargs rm -rf' % args.w3af_path, pipe=True)
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
    green('Bumped version.txt to %s' % args.release_version)

    return True

def update_changelog(args):
    changelog_fmt = '''
    %(date)s    Version %(version)s
    ======================================
    Github tag: https://github.com/andresriancho/w3af/tree/%(version)s
    Github milestone: https://github.com/andresriancho/w3af/issues?milestone=%(milestone)s

    * Change A
    * Change B
    ...
    * Change N
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
    #run_debug('joe changelog_file')

    return True

def run_sphinx(args):
    return True

def create_bz2(args):
    '''
    # clean previous builds that I made today
    rm w3af-$1.tar
    rm w3af-$1.tar.bz2

    # Create the tar archive
    tar -chpvf w3af-$1.tar ../../w3af

    echo "Creating bz2 file."

    bzip2 w3af-$1.tar

    echo "File created!"

    du -sh  w3af-$1.tar.bz2
    '''
    return True

def unittest_bz2(args):
    return True

def upload_files_to_site(args):
    '''
    echo "You may upload the new package using SFTP following these instructions:"
    echo "http://apps.sourceforge.net/trac/sourceforge/wiki/SFTP"
    '''
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
    run_all(
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

