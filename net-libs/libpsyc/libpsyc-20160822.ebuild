# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils autotools
DESCRIPTION="library for parsing and rendering PSYC packets more efficiently"
HOMEPAGE="http://about.psyc.eu/libpsyc"
LICENSE="AGPL-2"
EGIT_REPO_URI="/usr/local/src/${PN}
		git://git.cheettyiapsyciew.onion/${PN}
		git://git.psyced.org/git/${PN}"

case ${PV} in
"20160822")
	inherit git-r3
	EGIT_COMMIT="12080f60712b6d533b1f4b45788de8b4bcd2a3d9"
	;;
"20160823")
	# EGIT_COMMIT="a0abf99f72e4c248a798a56a31b4ebdaa81e2965"
	SRC_URI="http://www.psyced.org/files/${P}.tar.xz"
	;;
"20160913")
	# last snapshot available via http
	# EGIT_COMMIT="2e82f31f9d9281af0b3450d617458ca85dd12ee5"
	SRC_URI="http://www.psyced.org/files/${P}.tar.xz"
	;;
"20170107")
	inherit git-r3
	EGIT_COMMIT="8fe9264b7ef3dbf457c99c5bbfd767cb7561a37d"
	;;
*)
	inherit git-r3
	# last seen change
	EGIT_COMMIT="8fe9264b7ef3dbf457c99c5bbfd767cb7561a37d"
	;;
esac

SLOT="0"
IUSE="debug"
RDEPEND=""

src_compile {
        use debug && {
            append-flags -g -DDEBUG
			RESTRICT="${RESTRICT} nostrip"
        }
}

