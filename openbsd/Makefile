# $ID

ONLY_FOR_ARCHS=		i386 

COMMENT=		web auditing and attack framework

V=			1.0-rc2
DISTNAME=		w3af-${V}
PKGNAME=		${DISTNAME}
CATEGORIES =		security

HOMEPAGE=           	http://w3af.sourceforge.net
MAINTAINER=		Albert Hui <obsd.dev@gmail.com>

# GPLv2
PERMIT_PACKAGE_CDROM=   Yes
PERMIT_PACKAGE_FTP=     Yes
PERMIT_DISTFILES_CDROM= Yes
PERMIT_DISTFILES_FTP=   Yes

MASTER_SITES=		${MASTER_SITE_SOURCEFORGE:=w3af/}

#BUILD_DEPENDS=		
MODULES=		lang/python
#LIB_DEPENDS =		
RUN_DEPENDS =		:devel/py-fpconst
#REGRESS_DEPENDS = 	${RUN_DEPENDS}

# To-do
# post-install:

.include <bsd.port.mk>
