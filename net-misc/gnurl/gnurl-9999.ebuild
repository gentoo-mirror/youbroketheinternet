# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A reliable small footprint version of Curl based on gnutls only"
HOMEPAGE="https://gnunet.org/gnurl
		https://www.git.taler.net/?p=gnurl.git;a=summary"
if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 autotools eutils prefix
	EGIT_REPO_URI="https://git.taler.net/gnurl
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
	econf --disable-ntlm-wb
}

src_install() {
	default
}
