# Copyright 2018 ng0 <ng0@n0.is>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator toolchain-funcs
MY_P="VERSION_"$(replace_all_version_separators "_")

DESCRIPTION="simple markdown translator"

HOMEPAGE="https://github.com/kristapsdz/lowdown"
SRC_URI="https://github.com/kristapsdz/${PN}/archive/${MY_P}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${PN}-${MY_P}
LICENSE="ISC" # Actually OpenBSD.
SLOT="0"
KEYWORDS="~*"
IUSE=""
DEPEND="sci-libs/openlibm"
RDEPEND=""

src_prepare(){
	eapply_user
}

src_configure(){
	cat <<EOF "Makefile.configure"
		PREFIX="${EPREFIX}/usr"
		BINDIR="${EPREFIX}/usr/bin"
		SBINDIR="${EPREFIX}/usr/sbin"
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		MANDIR="${EPREFIX}/usr/share/man"
		INCLUDEDIR="${EPREFIX}/usr/include/lowdown"
		EXAMPLEDIR="${EPREFIX}/usr/share/examples/lowdown"
		CFLAGS="${CFLAGS} ${CPPFLAGS}"
		LDFLAGS="${LDFLAGS}"
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
EOF
	./configure
}

src_compile(){
	emake PREFIX="${EPREFIX}/usr" MANDIR="${EPREFIX}/usr/share/man"
}
