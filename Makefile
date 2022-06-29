# $NetBSD: Makefile,v 1.11 2021/12/22 16:07:04 schmonz Exp $

DISTNAME=	s6-networking-2.5.1.1
CATEGORIES=	net
MASTER_SITES=	${HOMEPAGE}
DISTFILES=	${DISTNAME}${EXTRACT_SUFX} ${MANPAGES}

MAINTAINER=	schmonz@NetBSD.org
HOMEPAGE=	https://skarnet.org/software/s6-networking/
COMMENT=	Suite of small networking utilities
LICENSE=	isc

MANPAGES=		v2.5.1.1.1.tar.gz
SITES.${MANPAGES}=	${MASTER_SITE_GITHUB:=flexibeast/s6-networking-man-pages/archive/}

USE_TOOLS+=		gmake
HAS_CONFIGURE=		yes
CONFIGURE_ARGS+=	--prefix=${PREFIX}
CONFIGURE_ARGS+=	--with-sysdeps=${PREFIX}/lib/skalibs/sysdeps
CONFIGURE_ARGS+=	--enable-absolute-paths

INSTALLATION_DIRS+=	${PKGMANDIR}/man7 ${PKGMANDIR}/man8

.include "options.mk"

.PHONY: do-install-manpages
post-install: do-install-manpages
do-install-manpages:
	cd ${WRKDIR}/${PKGBASE}-man-pages-*; for i in 7 8; do \
		for j in man$$i/*.$$i; do \
			${INSTALL_MAN} $$j \
			${DESTDIR}${PREFIX}/${PKGMANDIR}/man$$i; \
		done \
	done

BUILDLINK_API_DEPENDS.skalibs+=	skalibs>=2.12.0.0
.include "../../devel/skalibs/buildlink3.mk"
BUILDLINK_API_DEPENDS.s6-dns+=	s6-dns>=2.3.5.4
.include "../../net/s6-dns/buildlink3.mk"
.include "../../sysutils/s6/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
