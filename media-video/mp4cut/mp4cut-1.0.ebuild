# Distributed under the terms of the Affero GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Lossless M4V Scene Extractor"

LICENSE="AGPL"
SLOT="0"
DEPEND="dev-lang/perl media-video/gpac"

# isn't it pointless to have a list of architectures for architecture-independent packages?
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 amd64-fbsd sparc-fbsd x86-fbsd"

S="$WORKDIR"

src_install() {
	exeinto /usr/bin
	doexe "${FILESDIR}"/${PN}
}

