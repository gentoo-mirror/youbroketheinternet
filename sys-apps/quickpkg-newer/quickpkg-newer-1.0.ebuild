# Distributed under the terms of the Affero GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Make binary packages of each installed atom in the system"

LICENSE="AGPL"
SLOT="0"
DEPEND="sys-apps/portage dev-lang/perl virtual/perl-Term-ANSIColor"

# isn't it pointless to have a list of architectures for architecture-independent packages?
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 amd64-fbsd sparc-fbsd x86-fbsd"

# S="${WORKDIR}/../image"

src_unpack() {
#	elog "Workdir: ${WORKDIR}"
#	elog "S: ${S}"
	mkdir "$S"
}

#src_compile() {
#   perldoc -o nroff "${FILESDIR}"/${PN} >${PN}.8
#}

src_install() {
#   doman "${PN}.8"
	exeinto /usr/sbin
	doexe "${FILESDIR}"/quickpkg-newer
}

