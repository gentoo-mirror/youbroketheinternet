# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Graphical front-end tools for GNUnet."
HOMEPAGE="https://gnunet.org/"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"

DEPEND=">=x11-libs/gtk+-2.20.0
	=net-misc/gnunet-${PV}
	>=gnome-base/libglade-2.0
	dev-libs/libunique
	dev-util/glade"

# autotools banned in EAPI 6
if [[ ${PV} == "9999" ]] ; then
	inherit autotools eutils subversion user
	WANT_AUTOCONF="2.59"
	WANT_AUTOMAKE="1.11"
	WANT_LIBTOOL="2.2"
	AUTOTOOLS_AUTORECONF=1
	SRC_URI=""
	ESVN_REPO_URI="https://gnunet.org/svn/gnunet-gtk"
	ESVN_PROJECT="gnunet-gtk"
elif [[ ${PV} == "0.10.2_rc1" ]] ; then
	inherit autotools eutils subversion user
	WANT_AUTOCONF="2.59"
	WANT_AUTOMAKE="1.11"
	WANT_LIBTOOL="2.2"
	AUTOTOOLS_AUTORECONF=1
	SRC_URI=""
	ESVN_REPO_URI="https://gnunet.org/svn/gnunet-gtk"
	ESVN_PROJECT="gnunet-gtk"
	ESVN_REVISION=37011
fi
# else
# 	inherit user
# 	SRC_URI="mirror://gnu/gnunet/${P}.tar.gz"
# fi

src_prepare() {
	subversion_src_prepare
	eautoreconf
	default
	# if [[ ${PV} == "9999" ]] ; then
	# 	subversion_src_prepare
	# 	autotools-utils_src_prepare
	# fi
}

# src_unpack() {
# 	if [[ ${PV} != "9999" ]] ; then
#            unpack ${A}
#            cd "${S}"
#            AT_M4DIR="${S}/m4" eautoreconf
# 	fi
# }

src_configure() {
	econf --with-gnunet=/usr
}

src_compile() {
	emake
}

src_install() {
	default
	#emake DESTDIR="${D}" install
}
