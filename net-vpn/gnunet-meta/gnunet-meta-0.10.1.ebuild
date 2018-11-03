# Copyright 1999-2016 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

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

IUSE="+gtk experimental +gnurl curl qr"
REQUIRED_USE="?? ( curl gnurl )"

RDEPEND="
	=net-vpn/gnunet-${PV}
	experimental? ( =net-vpn/gnunet-${PV}[experimental,extra] )
	qr? ( =net-vpn/gnunet-${PV}[experimental,extra,qr]
		  =net-vpn/gnunet-${PV}[qr] )
	gtk? ( =net-vpn/gnunet-gtk-${PV} )
	gnurl? ( =net-vpn/gnunet-${PV}[gnurl,curl] )
	curl? ( =net-vpn/gnunet-${PV}[curl,-gnurl] )"
