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

case ${PV} in
"0.10.1_pre01021")
	KEYWORDS="amd64"
	;;
"9999")
	KEYWORDS="~amd64"
	;;
"0.10.1")
	KEYWORDS="~amd64"
	;;
*)
esac

IUSE="+gtk experimental +gnurl curl conversation qr"
REQUIRED_USE="?? ( curl gnurl )"

RDEPEND="
	=net-misc/gnunet-${PV}
	experimental? ( =net-misc/gnunet-${PV}[experimental,extra] )
	conversation? ( =net-misc/gnunet-${PV}[experimental,extra,conversation] )
	qr? ( =net-misc/gnunet-${PV}[experimental,extra,qr]
		  =net-misc/gnunet-${PV}[qr] )
	gtk? ( =net-misc/gnunet-gtk-${PV} )
	gnurl? ( =net-misc/gnunet-${PV}[gnurl,curl] )
	curl? ( =net-misc/gnunet-${PV}[curl,-gnurl] )"
