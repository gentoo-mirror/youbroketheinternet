# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A reliable small footprint version of Curl based on gnutls only"
HOMEPAGE="https://gnunet.org/gnurl
		https://www.git.taler.net/?p=gnurl.git;a=summary"
if [[ ${PV} == "9999" ]] ; then
 	inherit git-r3 autotools eutils prefix
 	EGIT_REPO_URI="https://git.taler.net/gnurl
				   https://gnunet.org/git/gnurl
				   git://git.taler.net/gnurl"
 	EGIT_CLONE_TYPE="shallow"
else
	inherit autotools eutils prefix
	SRC_URI="https://gnunet.org/sites/default/files/${P}.tar.bz2"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dane"

RDEPEND=">=net-libs/gnutls-3[dane?]
	sys-libs/zlib"
DEPEND="${RDEPEND}"

DOCS=( CHANGES README docs/FEATURES docs/INTERNALS \
	docs/MANUAL docs/FAQ docs/BUGS docs/CONTRIBUTE )

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
		--disable-tftp
}

src_install() {
	default
}
