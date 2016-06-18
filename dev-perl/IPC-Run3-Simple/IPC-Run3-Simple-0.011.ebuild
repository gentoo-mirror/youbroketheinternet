# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=AYOUNG
DIST_VERSION=${PV}
inherit perl-module

DESCRIPTION="Make IPC::Run3 even easier to use"

LICENSE="|| ( BSD-2 Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos"
IUSE="test"

DEPEND="
	dev-perl/IPC-Run3
	dev-perl/Module-Build
"
