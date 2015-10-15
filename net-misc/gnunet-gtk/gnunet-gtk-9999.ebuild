# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# author: lynX
# author: krosos (krosos.sdf.org)

EAPI=5

DESCRIPTION="Graphical front-end tools for GNUnet."
HOMEPAGE="https://gnunet.org/"

KEYWORDS="~amd64 ~ppc64 ~x86"
LICENSE="GPL-3"
SLOT="0"
IUSE=""

# MY_P=${PN}-${PV/_/}
# S="${WORKDIR}/${MY_P}"

DEPEND=">=x11-libs/gtk+-2.20.0
	=net-misc/gnunet-${PV}
	>=gnome-base/libglade-2.0
"

if [[ ${PV} == "9999" ]] ; then
	inherit eutils autotools autotools-utils subversion user
	WANT_AUTOCONF="2.59"
	WANT_AUTOMAKE="1.11"
	WANT_LIBTOOL="2.2"
	AUTOTOOLS_AUTORECONF=1
	SRC_URI=""
	ESVN_REPO_URI="https://gnunet.org/svn/gnunet-gtk"
	ESVN_PROJECT="gnunet-gtk"
else
	inherit user
	# SRC_URI="ftp://ftp.gnu.org/gnu/gnunet/${PN}-${MY_PV}.tar.gz"
	SRC_URI="mirror://gnu/gnunet/${P}.tar.gz"
fi

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		subversion_src_prepare
		autotools-utils_src_prepare
	fi
}

#src_unpack() {
#	unpack ${A}
#	cd "${S}"
#	AT_M4DIR="${S}/m4" eautoreconf
#}

# was: ${PF}"
src_configure() {
		econf \
		--with-gnunet=/usr || die "econf failed"
}
#                --docdir="${EPREFIX}/usr/share/doc/${PF}" \

src_compile() {
	emake || die "emake failed"
}

# todo: solve issue with doc folders as described in gnunet-9999
src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README COPYING
}
