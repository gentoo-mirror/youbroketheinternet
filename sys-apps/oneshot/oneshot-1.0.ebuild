# Distributed under the terms of the Affero GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Usability frontend to emerge to keep you from breaking your system"

LICENSE="AGPL"
SLOT="0"
DEPEND="sys-apps/portage dev-lang/perl virtual/perl-Term-ANSIColor"

# isn't it pointless to have a list of architectures for architecture-independent packages?
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 amd64-fbsd sparc-fbsd x86-fbsd"

S="${WORKDIR}/../image"

src_install() {
	exeinto /usr/sbin
	doexe "${FILESDIR}"/oneshot-help
	cd "$S/usr/sbin" || die "Cannot chdir into '$S/usr/sbin'"
	./oneshot-help install || die "Cannot run 'oneshot-help install'"
}

