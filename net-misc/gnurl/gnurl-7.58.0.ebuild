# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A reliable small footprint version of Curl based on gnutls only"
HOMEPAGE="https://gnunet.org/gnurl"

inherit autotools eutils prefix versionator

SRC_URI="https://ftp.gnu.org/gnu/gnunet/${P}.tar.xz -> ${P}.tar.xz"
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
	econf --disable-ntlm-wb
}

src_install() {
	default
}
