# Copyright 2018 ng0 <ng0@n0.is>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator
MY_P="VERSION_"$(replace_all_version_separators "_")

DESCRIPTION="simple markdown translator"

HOMEPAGE="https://github.com/kristapsdz/lowdown"
SRC_URI="https://github.com/kristapsdz/${PN}/archive/${MY_P}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${PN}-${MY_P}
LICENSE="OpenBSD"
SLOT="0"
KEYWORDS="~*"
IUSE=""
DEPEND="sci-libs/openlibm"
RDEPEND=""

src_prepare(){
	eapply_user
}

src_configure(){
	touch "Makefile.configure"
	./configure
}

src_compile(){
	emake PREFIX="${EPREFIX}/usr" MANDIR="${EPREFIX}/usr/share/man"
}
