# Copyright 1999-2016 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Written by, in historic order: vonlynX, ng0.
# https://gnunet.org/gentoo-build is outdated, please ignore.

EAPI=6

DESCRIPTION="Graphical front-end tools for GNUnet."
HOMEPAGE="https://gnunet.org/"
LICENSE="GPL-3"
SLOT="0"

ESVN_PROJECT="gnunet-gtk"
ESVN_REPO_URI="https://gnunet.org/svn/gnunet-gtk"

# if you're a gnunet developer, you can put a symlink to your local git here:
EGIT_REPO_URI="/usr/local/src/${PN}
            https://gnunet.org/git/${PN}.git
            git://gnunet.org/${PN}.git
            https://github.com/gnunet/${PN}"

IUSE="debug qr"

RDEPEND="
	x11-libs/gtk+:3
	=net-vpn/gnunet-${PV}
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
"9999")
	# use latest git
	inherit autotools git-r3
	KEYWORDS="~amd64 ~x86"
	;;
"999")
	# use latest svn
	inherit autotools subversion
	SRC_URI=""
	S="${WORKDIR}/${PN}"
	KEYWORDS="~amd64 ~x86"
	;;
"0.10.1")
	inherit autotools
	SRC_URI="mirror://gnu/gnunet/${P}.tar.gz"
	S="${WORKDIR}/${PN}"
	KEYWORDS="~amd64 ~x86"
	;;
"0.10.1_pre01021")
	inherit autotools subversion
	SRC_URI=""
	ESVN_REVISION="37273"
	S="${WORKDIR}/${PN}"
	KEYWORDS="amd64 ~x86"
	;;
*)
	# last working change
	inherit autotools subversion
	SRC_URI=""
	ESVN_REVISION="37273"
	S="${WORKDIR}/${PN}"
	KEYWORDS="amd64 ~x86"
	;;
esac

src_prepare() {
	if [[ "${PV}" == "0.10.1_pre01021" ]]; then
		#subversion_src_prepare
		eautoreconf
		default
	elif [[ "${PV}" == "9999" ]]; then
		#subversion_src prepare
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
