# Copyright 1999-2014 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=GLEACH
MODULE_VERSION=${PV}
inherit perl-module

DESCRIPTION="A library for reading and editing audio meta data, commonly known as 'tags'"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~mips ppc ppc64 ~sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="test"

SRC_TEST="do"
