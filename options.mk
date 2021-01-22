# $NetBSD: options.mk,v 1.3 2021/01/22 16:20:38 schmonz Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.s6-networking
PKG_SUPPORTED_OPTIONS+=	execline tls
PKG_SUGGESTED_OPTIONS+=	tls

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mexecline)
.  include "../../lang/execline/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--disable-execline
.endif

PLIST_VARS=		tls
.if !empty(PKG_OPTIONS:Mtls)
PLIST.tls=		yes
.  include "../../security/bearssl/buildlink3.mk"
CONFIGURE_ARGS+=	--enable-ssl=bearssl

PKG_USERS_VARS+=	UCSPI_SSL_USER
PKG_GROUPS_VARS+=	UCSPI_SSL_GROUP
PKG_GROUPS+=		${UCSPI_SSL_GROUP}
PKG_USERS+=		${UCSPI_SSL_USER}:${UCSPI_SSL_GROUP}

SUBST_CLASSES+=		paths
SUBST_STAGE.paths=	pre-configure
SUBST_FILES.paths=	s6-pkgsrc-cadir
SUBST_VARS.paths=	SH SETENV SSLDIR

post-extract:
	for f in s6-pkgsrc-cadir; do \
		${CP} ${FILESDIR}/$$f.sh ${WRKSRC}/$$f; \
	done
post-install:
	for f in s6-pkgsrc-cadir; do \
		${INSTALL_SCRIPT} ${WRKSRC}/$$f ${DESTDIR}${PREFIX}/bin/$$f; \
	done
.endif
