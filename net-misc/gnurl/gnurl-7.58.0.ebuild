# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A reliable small footprint version of Curl based on gnutls only"
HOMEPAGE="https://gnunet.org/gnurl"

inherit autotools eutils prefix versionator

#RC_URI="https://gnunet.org/sites/default/files/${P}.tar.bz2 -> ${P}.tar.bz2"
SRC_URI="https://ftp.gnu.org/gnu/gnunet/${P}.tar.bz2 -> ${P}.tar.bz2"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~"
IUSE="dane"

RDEPEND=">=net-libs/gnutls-3[dane?]
	sys-libs/zlib"
DEPEND="${RDEPEND}"

DOCS=( CHANGES README docs/FEATURES docs/MANUAL docs/FAQ docs/BUGS )

# TODO: check if this phase is still appropriate in content!
src_prepare() {
	sed -i '/LD_LIBRARY_PATH=/d' configure.ac || die #382241
	eapply_user
	eprefixify gnurl-config.in
	eautoreconf
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
