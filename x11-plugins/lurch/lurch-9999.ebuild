# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 eutils

DESCRIPTION="OMEMO for libpurple - interoperable with other OMEMO clients"
HOMEPAGE="https://github.com/gkdr/lurch"
EGIT_REPO_URI="https://github.com/gkdr/lurch"
EGIT_BRANCH="dev"

S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	net-im/pidgin
	dev-libs/libxml2
	dev-db/sqlite
	dev-libs/mxml"

RDEPEND="${DEPEND}"

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install || die "email install failed"
}
