# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Coypright © 2016 ng0

EAPI=6

DESCRIPTION="Meta package for GNUnet"
HOMEPAGE="https://gnunet.org"
SRC_URI=""

# metapackage
LICENSE="GPL-3"
SLOT="0"
# more than this:
KEYWORDS="~amd64"
IUSE="+gtk experimental +gnurl curl"
REQUIRED_USE="?? ( curl gnurl )"

RDEPEND="
	=net-misc/gnunet-${PV}
	experimental? ( =net-misc/gnunet-${PV}[experimental,extra] )
	gtk? ( =net-misc/gnunet-gtk-${PV} )
	gnurl? ( =net-misc/gnunet-${PV}[gnurl] )
	curl? ( =net-misc/gnunet-${PV}[curl,-gnurl] )"
