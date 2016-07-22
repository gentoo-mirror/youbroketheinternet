# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Coypright © 2016 ng0

EAPI=6

DESCRIPTION="Meta package for GNUnet"
HOMEPAGE="https://gnunet.org"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk experimental gnurl curl"
REQUIRED_USE="?? ( curl gnurl )"

RDEPEND="
		net-misc/gnunet
		experimental? ( net-misc/gnunet[experimental,extra] )
		gtk? ( net-misc/gnunet-gtk )
		gnurl? ( net-misc/gnunet[gnurl] )
		curl? ( net-misc/gnunet[curl,-gnurl] )"
