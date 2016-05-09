# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Enhanced telnet client with automation macros for MUD interaction use"
HOMEPAGE="http://hoopajoo.net/projects/powwow.html"
inherit autotools eutils prefix
SRC_URI="http://hoopajoo.net/static/projects/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="psyced"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-libs/ncurses"

DOCS=( ChangeLog Config.demo Hacking NEWS powwow.doc \
				 powwow.help README TODO )

src_prepare() {
	if use psyced ; then
		eapply "${FILESDIR}"/defines.h.patch
	fi
	eapply "${FILESDIR}"/${P}-underlinking.patch
	# note that that the extra, seemingly-redundant files installed are
	# actually used by in-game help commands
	sed -i \
		-e "s/pkgdata_DATA = powwow.doc/pkgdata_DATA = /" \
		Makefile.am || die
	mv configure.in configure.ac || die
	eautoreconf
	eapply_user
	#eprefixify gnurl-config.in
	default
}

src_configure() {
	#econf \
	default
}

src_install() {
	default
}
