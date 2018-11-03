# Copyright 1999-2014 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=PEVANS
MODULE_VERSION=${PV}
inherit perl-module

DESCRIPTION="C Header to Perl Module converter"

SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86 x86"
IUSE=""

DEPEND="
	dev-perl/Module-Build
"
RDEPEND="${DEPEND}"

SRC_TEST="do"
