# Distributed under the terms of the Affero GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Recursively search for regular expressions in ZIP compatible archive formats"

LICENSE="AGPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
DEPEND="dev-lang/perl dev-perl/Archive-Zip"

S="$WORKDIR"

src_install() {
	exeinto /usr/bin

	# It's a shame the name "zipgrep" is taken by a vastly inferior
	# shell script. Please provide a USE flag to remove it from the
	# unzip distribution so this one can take over its place.
	doexe "${FILESDIR}"/ziprgrep
}

