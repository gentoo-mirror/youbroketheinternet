# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Graphical front-end tools for GNUnet."
HOMEPAGE="https://gnunet.org/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=x11-libs/gtk+-2.20.0
	=net-misc/gnunet-${PV}
	>=gnome-base/libglade-2.0
	dev-libs/libunique
	dev-util/glade"

if [[ ${PV} == "9999" ]] ; then
	inherit autotools eutils subversion user
	SRC_URI=""
	ESVN_REPO_URI="https://gnunet.org/svn/gnunet-gtk"
	ESVN_PROJECT="gnunet-gtk"
else
	inherit user autotools eutils
	SRC_URI="mirror://gnu/gnunet/${P}.tar.gz"
fi

WANT_AUTOCONF="2.59"
WANT_AUTOMAKE="1.11"
WANT_LIBTOOL="2.2"
AUTOTOOLS_AUTORECONF=1

#S="${WORKDIR}/${PF}/${PN}"
S="${WORKDIR}/${PN}"

src_prepare() {
	if [[ "${PV}" == "9999" ]]; then
		subversion_src_prepare
		eautoreconf
		default
	else
		eautoreconf
		default
	fi
}

# src_unpack() {
# 	if [[ ${PV} != "9999" ]] ; then
#            unpack ${A}
#            cd "${S}"
#            AT_M4DIR="${S}/m4" eautoreconf
# 	fi
# }

# why?
src_configure() {
	econf --with-gnunet="${ROOT}/usr"
}

#src_compile() {
#	#emake
#	default
#}

src_install() {
	default
	#emake DESTDIR="${D}" install
}
