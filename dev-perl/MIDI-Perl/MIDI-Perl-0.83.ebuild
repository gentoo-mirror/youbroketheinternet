# Copyright 1999-2014 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=CONKLIN
MODULE_VERSION=${PV}
inherit perl-module

DESCRIPTION="Read, compose, modify and write MIDI files"

SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86 x86"
IUSE=""

DEPEND="
	dev-perl/Module-Build
"
RDEPEND="${DEPEND}"

SRC_TEST="do"

pkg_preinst() {
		exeinto /usr/bin
		doexe "${FILESDIR}"/midisplit
}
