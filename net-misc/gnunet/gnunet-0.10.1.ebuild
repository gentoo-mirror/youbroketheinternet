# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# 
# taken from https://338909.bugs.gentoo.org/attachment.cgi?id=381924
# referenced at https://bugs.gentoo.org/show_bug.cgi?id=338909
# merged with 9999 variant from emery overlay
# refined 2015-07 by carlo von lynX of youbroketheinternet.org

EAPI=5

# No longer accurate: GNUnet isn't limited to P2P
#DESCRIPTION="GNUnet is a framework for secure peer-to-peer networking."
DESCRIPTION="Cryptographic GNU Mesh/Underlay Network Routing Layer"
HOMEPAGE="https://gnunet.org/"
LICENSE="GPL-3"

if [[ ${PV} == "9999" ]] ; then
	inherit eutils autotools autotools-utils subversion user
	WANT_AUTOCONF="2.59"
	WANT_AUTOMAKE="1.11"
	WANT_LIBTOOL="2.2"
	AUTOTOOLS_AUTORECONF=1
	SRC_URI=""
	ESVN_REPO_URI="https://gnunet.org/svn/gnunet"
	ESVN_PROJECT="gnunet"
else
	inherit user
	# we could append gnunet-gtk to SRC_URI here
	# and have a single ebuild for both, but that
	# won't help with the separate svn's
	SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
fi

AUTOTOOLS_IN_SOURCE_BUILD=1

KEYWORDS="~amd64 ~arm ~ppc64 ~x86"

RESTRICT="test"

SLOT="0"
IUSE="experimental +httpd mysql nls postgres +sqlite X"
REQUIRED_USE="
	!mysql? ( !postgres? ( sqlite ) )
	!mysql? ( !sqlite? ( postgres ) )
	!postgres? ( !mysql? ( sqlite ) )
	!postgres? ( !sqlite? ( mysql ) )
	!sqlite? ( !postgres? ( mysql ) )
	!sqlite? ( !mysql? ( postgres ) )
"

RDEPEND="
	>=net-misc/curl-7.21.0
	>=media-libs/libextractor-0.6.1
	>=dev-libs/libgcrypt-1.6
	>=dev-libs/libunistring-0.9.2
	net-misc/gnurl
	sys-libs/ncurses
	sys-libs/zlib
	httpd? ( >=net-libs/libmicrohttpd-0.9.42[messages] )
	mysql? ( >=virtual/mysql-5.1 )
	nls? ( sys-devel/gettext )
	postgres? ( >=dev-db/postgresql-server-8.3 )
	sqlite? ( >=dev-db/sqlite-3.0 )
	X? (
		x11-libs/libXt
		x11-libs/libXext
		x11-libs/libX11
		x11-libs/libXrandr
	)
"
DEPEND="
	${RDEPEND}
	sys-devel/automake:1.14
"

pkg_setup() {
	enewgroup gnunetdns
	enewuser  gnunet
}

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		subversion_src_prepare
		autotools-utils_src_prepare
	fi
	epatch "${FILESDIR}"/install.diff
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable nls) \
		$(use_enable experimental) \
		$(use_with httpd microhttpd) \
		$(use_with mysql) \
		$(use_with postgres) \
		$(use_with sqlite) \
		$(use_with X x)
}

# why this?
#
# src_compile() {
#	MAKEOPTS="-j1" emake
# }

src_install() {
	MAKEOPTS="-j1" emake DESTDIR="${D}" install
	newinitd "${FILESDIR}"/gnunet.initd gnunet
	insinto /etc/gnunet
	doins "${FILESDIR}"/gnunet.conf
	keepdir /var/{lib,log}/gnunet
	fowners gnunet:gnunet /var/lib/gnunet /var/log/gnunet
}

pkg_postinst() {
	einfo
	einfo "To configure"
	einfo "	 1) Add actual user(s) to the gnunet group"
	einfo "	 2) Edit the system-wide config file '/etc/gnunet/gnunet.conf'"
	einfo "	    preferably using 'gnunet-setup -c /etc/gnunet/gnunet.conf'"
	einfo "	    ('gnunet-setup' is part of the gnunet-gtk package)"
	einfo "	 3) You may want to choose other bootstrap nodes than the ones"
	einfo "	    provided in /usr/share/gnunet/hellos - or remove them if you"
	einfo "	    don't want the agencies to know you are using GNUnet (yet)"
	einfo
}
