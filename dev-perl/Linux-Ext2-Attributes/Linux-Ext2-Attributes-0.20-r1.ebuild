# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DJCOLLINS
MODULE_VERSION=${PV}
inherit perl-module

DESCRIPTION="Attributes for Ext Filesystems"

SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86 x86"
IUSE=""

DEPEND="
	dev-perl/Module-Build
	dev-perl/ExtUtils-H2PM
"
RDEPEND="${DEPEND}"

SRC_TEST="do"

src_prepare() {
	epatch "${FILESDIR}/nocompr.patch"
}
