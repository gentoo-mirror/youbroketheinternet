# Distributed under the terms of the Affero GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Command line UX frontend to dm-crypt's cryptsetup with support for multiple file systems"

LICENSE="AGPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
DEPEND="dev-lang/perl virtual/perl-Term-ANSIColor sys-fs/cryptsetup sys-apps/util-linux"

S="$WORKDIR"

src_install() {
	exeinto /usr/sbin
	doexe "${FILESDIR}"/${PN}
}

