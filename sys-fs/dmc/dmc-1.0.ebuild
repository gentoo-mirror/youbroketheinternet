# Distributed under the terms of the Affero GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Command line UX frontend to dm-crypt's cryptsetup with support for multiple file systems"

LICENSE="AGPL"
SLOT="0"
DEPEND="dev-lang/perl virtual/perl-Term-ANSIColor sys-fs/cryptsetup sys-apps/util-linux"

# isn't it pointless to have a list of architectures for architecture-independent packages?
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 amd64-fbsd sparc-fbsd x86-fbsd"
# it all depends on the dependencies. they may not be running on all architectures
# but it is not my job to figure that out. emerge can ask them directly.

S="$WORKDIR"

src_install() {
	exeinto /usr/sbin
	doexe "${FILESDIR}"/${PN}
}

