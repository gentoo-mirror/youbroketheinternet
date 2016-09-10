# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A reliable small footprint version of Curl based on gnutls only"
HOMEPAGE="https://gnunet.org/gnurl"

inherit autotools eutils prefix versionator

#MY_PV="$(replace_all_version_separators '_')"
MY_P=${PN}-$(replace_all_version_separators '_')
SRC_URI="https://gnunet.org/sites/default/files/${MY_P}.tar.bz2 -> ${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~"
IUSE="dane"

RDEPEND=">=net-libs/gnutls-3[dane?]
	sys-libs/zlib"
DEPEND="${RDEPEND}"

DOCS=( CHANGES README docs/FEATURES docs/INTERNALS \
	docs/MANUAL docs/FAQ docs/BUGS docs/CONTRIBUTE )

S=${WORKDIR}/${MY_P}

# TODO: check if this phase is still appropriate in content!
src_prepare() {
		sed -i '/LD_LIBRARY_PATH=/d' configure.ac || die #382241

		eapply_user
		eprefixify gnurl-config.in
		eautoreconf

		# Fix conflicts with Curl: UGLY HACK AHEAD /!\
		# (The fork maintainer should do that.)
		# XXX: fixed in upcoming release.

		# FIX: Rename include/curl to include/gnurl
		mv include/curl include/gnurl
		# FIX: Tune explicit paths in source files (~400 lines)
		grep -ERl 'include(.*curl/|/curl)' | \
			xargs sed -i -r \
				  -e 's:include/curl:include/gnurl:g' \
				  -e 's:(include.*)curl/:\1gnurl/:g' || die
		# FIX: Tune relative 'curl' path in makefiles under include/
		grep -Rl 'SUBDIRS\s*=\s*curl' | \
			xargs sed -i -r 's:(SUBDIRS\s*=\s*)curl:\1@PACKAGE@:g' || die
		# FIX: Tune relative 'curl' path in makefiles, install phase
		grep -Rl 'pkgincludedir\s*=\s*.*curl' | \
			xargs sed -i -r 's:(pkgincludedir\s*=\s*.*)curl:\1@PACKAGE@:g' || die
		# FIX: Skip examples and man3
		grep -Rl 'SUBDIRS\s*=\s*.*libcurl' docs/ | \
			xargs sed -i -r '/SUBDIRS\s*=\s*.*libcurl/s:^:#:g' || die
		default
}

src_configure() {
	econf \
		--enable-ipv6 \
		--with-gnutls \
		--without-cyassl \
		--without-darwinssl \
		--without-libmetalink \
		--without-librtmp \
		--without-libssh2 \
		--without-nghttp2 \
		--without-nss \
		--without-polarssl \
		--without-ssl \
		--without-winidn \
		--without-winssl \
		--disable-dict \
		--disable-file \
		--disable-ftp \
		--disable-gopher \
		--disable-imap \
		--disable-ldap \
		--disable-ntlm-wb \
		--disable-pop3 \
		--disable-rtsp \
		--disable-smtp \
		--disable-sspi \
		--disable-telnet \
		--disable-tftp \
		--disable-smb
}

src_install() {
	default
}
