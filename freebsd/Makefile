# New ports collection makefile for:	w3af
#
# Original creator
# ================
#
# Date created:				Wed Aug 29 21:44:33 CEST 2007
# Whom:					Stefan Esser <se@FreeBSD.org>
#
# Maintainer
# ==========
#
# Date updated:				Sun Mar 1 2009
# Whom:					sbrabez@gmail.com
#
#

PORTNAME=	w3af
PORTVERSION=	0.1.20080922		# TODO: Upgrade port version?
CATEGORIES=	security python www
MASTER_SITES=	${MASTER_SITE_SOURCEFORGE}
MASTER_SITE_SUBDIR=	w3af
DISTNAME=	${PORTNAME}-beta7-r1813		# TODO: Remember to port rc1

MAINTAINER=	sbrabez@gmail.com
COMMENT=	w3af - Web Application Attack and Audit Framework

#
LIB_DEPENDS=	tidy-0.99.0:${PORTSDIR}/www/py-utidy		# TODO: utidy was removed from the dependency list
BUILD_DEPENDS=	${PYTHON_SITELIBDIR}/SOAPpy:${PORTSDIR}/net/py-soappy-devel \
		${PYTHON_SITELIBDIR}/BeautifulSoup.py:${PORTSDIR}/www/py-beautifulsoup \
		${PYTHON_SITELIBDIR}/json.py:${PORTSDIR}/devel/py-json-py \
		${PYTHON_SITELIBDIR}/pyPdf/pdf.py:${PORTSDIR}/print/py-pdf\
		${PYTHON_SITELIBDIR}/OpenSSL/SSL.so:${PORTSDIR}/security/py-openssl 
		# TODO: To get a complete list of dependencies, read the dependencyCheck.py files. There is one for the console
		# and one for the GUI. I think that it would be a good idea to have two different w3af packages in freebsd, one
		# with the console (w3af-cli) and one with the console and the gui (w3af), each with it's dependencies.
RUN_DEPENDS=	${BUILD_DEPENDS}

WRKSRC=		${WRKDIR}/${PORTNAME}
USE_BZIP2=	yes
USE_PYTHON=	2.5+		# TODO: w3af only supports python 2.5, I havent tested it with 2.6, so installing with 2.5 (strict)
				# not with >=2.5 would be better

OPTIONS=	GUI "Support for graphical user interface" off

.if defined(WITH_GUI)
RUN_DEPENDS+=	${PYTHON_SITELIBDIR}/dot.py:${PORTSDIR}/graphics/py-pydot
.endif

post-patch:
	@${GREP} -lr '/usr/bin/python' ${WRKSRC} | \
		${XARGS} ${REINPLACE_CMD} -i "" \
			-E "s!/usr/bin/python2?!${PYTHON_CMD}!"

do-build:
	@${MKDIR} ${WRKDIR}/build
	@${CP} -R ${WRKSRC}/w3af_console ${WRKDIR}/build/w3af_console.py
	@${CP} -R ${WRKSRC}/w3af_gui ${WRKDIR}/build/w3af_gui.py
.for f in core plugins profiles scripts tools
	@${CP} -R ${WRKSRC}/${f} ${WRKDIR}/build/
.endfor
	@${PYTHON_CMD} -m compileall ${WRKDIR}/build
	@${PYTHON_CMD} -O -m compileall ${WRKDIR}/build
.for f in w3af w3af_gui
	@${SED} -e 's:%%PATH%%:${PYTHON_SITELIBDIR}/${PORTNAME}/:' \
		-e 's:%%PYTHON_CMD%%:${PYTHON_CMD}:' \
		< ${FILESDIR}/${f}.sh > ${WRKDIR}/${f}.sh
.endfor

do-install:
	@${MKDIR} ${PYTHON_SITELIBDIR}/${PORTNAME}/
	@${CP} -R ${WRKDIR}/build/* ${PYTHON_SITELIBDIR}/${PORTNAME}/
	@${INSTALL_SCRIPT} ${WRKDIR}/w3af.sh ${LOCALBASE}/bin/w3af
	@${INSTALL_SCRIPT} ${WRKDIR}/w3af_gui.sh ${LOCALBASE}/bin/w3af_gui

.include <bsd.port.mk>
