# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils autotools
DESCRIPTION="library for parsing and rendering PSYC packets more efficiently"
HOMEPAGE="http://about.psyc.eu/libpsyc"
LICENSE="AGPL-2"
EGIT_REPO_URI="git://git.psyced.org/git/libpsyc"

case ${PV} in
"20160822")
	# EGIT_COMMIT="12080f60712b6d533b1f4b45788de8b4bcd2a3d9"
	# last snapshot available via http
	SRC_URI="http://www.psyced.org/files/${P}.tar.xz"
	;;
*)
	inherit git-r3
	# last seen change
	EGIT_COMMIT="12080f60712b6d533b1f4b45788de8b4bcd2a3d9"
	;;
esac

SLOT="0"
IUSE=""
RDEPEND=""

