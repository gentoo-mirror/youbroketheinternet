# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Coypright © 2016 ng0

EAPI=6

DESCRIPTION="Graphical front-end tools for GNUnet."
HOMEPAGE="https://gnunet.org/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="debug qr"

RDEPEND="
	x11-libs/gtk+:3
	=net-misc/gnunet-${PV}
	>=gnome-base/libglade-2.0
	dev-libs/libunique:3
	dev-util/glade:*"
	#net-libs/gnutls
	#media-libs/libextractor
	#qr? ( media-gfx/qrencode )
	#x11-libs/gdk-pixbuf
	#dev-util/glade"
	#virtual/pkgconfig

DEPEND="${RDEPEND}"
#		sys-devel/automake:1.14"
#S="${WORKDIR}/${PN}"
case ${PV} in
"0.10.1")
	inherit autotools
	SRC_URI="mirror://gnu/gnunet/${P}.tar.gz"
	S="${WORKDIR}/${PN}"
	;;
"9999")
	inherit autotools subversion
	SRC_URI=""
	ESVN_REPO_URI="https://gnunet.org/svn/gnunet-gtk"
	ESVN_PROJECT="gnunet-gtk"
	S="${WORKDIR}/${PN}"
	;;
"999999")
	inherit autotools subversion
	SRC_URI=""
	ESVN_REPO_URI="https://gnunet.org/svn/gnunet-gtk"
	ESVN_PROJECT="gnunet-gtk"
	ESVN_REVISION="37273"
	S="${WORKDIR}/${PN}"
	;;
*)
# last working change
       inherit autotools subversion
       SRC_URI=""
       ESVN_REPO_URI="https://gnunet.org/svn/gnunet-gtk"
       ESVN_PROJECT="gnunet-gtk"
       ESVN_REVISION="37273"
       S="${WORKDIR}/${PN}"
       ;;
esac

src_prepare() {
	if [[ "${PV}" == "999999" ]]; then
		subversion_src_prepare
		eautoreconf
		default
	elif [[ "${PV}" == "9999" ]]; then
	     	subversion_src prepare
		eautoreconf
		default
	else
		eautoreconf
		default
	fi
}

src_configure() {
	econf \
		--with-gnunet="/usr"
}

src_compile() {
	default
}

src_install() {
	default
}
