# Distributed under the terms of the Affero GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="git commit command that preserves the privacy of working habits"

LICENSE="AGPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
DEPEND="dev-vcs/git"

S="$WORKDIR"

src_install() {
	exeinto /usr/bin
	doexe "${FILESDIR}"/git-commit-private
}

