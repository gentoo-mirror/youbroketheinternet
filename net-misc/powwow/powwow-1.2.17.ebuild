# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Enhanced telnet client with automation macros for MUD interaction use"
HOMEPAGE="http://hoopajoo.net/projects/powwow.html"
inherit autotools eutils
SRC_URI="http://hoopajoo.net/static/projects/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="cmdsep"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-libs/ncurses"

DOCS=( ChangeLog Config.demo Hacking NEWS powwow.doc \
				powwow.help README TODO )

src_prepare() {
	if use cmdsep ; then
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
	default
}

src_configure() {
	default
}

# FIXME: powwow.6 still sends manual into games section
#
# the games section stems from the days when systems administrators
# would decide whether students are allowed to play games or not,
# so it is generally questionable to put *anything* into section 6.
#
src_install() {
	default
}

pkg_postinst() {
	elog " "
	elog "You enabled the cmdsep useflag which changes the"
	elog "CMDSEP from \';\' to \'\\\', this way allowing you"
	elog "to wink in conversations.  ;-)"
	elog " "
}
