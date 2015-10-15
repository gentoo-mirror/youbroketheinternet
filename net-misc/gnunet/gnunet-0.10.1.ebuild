# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# taken from https://338909.bugs.gentoo.org/attachment.cgi?id=381924
# referenced at https://bugs.gentoo.org/show_bug.cgi?id=338909
# merged with 9999 variant from emery overlay
# refined 2015-07 by carlo von lynX of youbroketheinternet.org
# 2015-10 by krosos (krosos.sdf.org)

EAPI=5

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
	inherit eutils user
	# we could append gnunet-gtk to SRC_URI here
	# and have a single ebuild for both, but that
	# won't help with the separate svn's
	SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
fi

AUTOTOOLS_IN_SOURCE_BUILD=1

KEYWORDS="~amd64 ~arm ~ppc64 ~x86"

# todo: test hook for building tests.
RESTRICT="test"

SLOT="0"
IUSE="+httpd +sqlite postgresql mysql nls X +dane +gnutls +ssl experimental conversation qr tex +sudo gui"
# +sudo is a bad hack to get configure --with-sudo as gnunet builds in a silly way.
#

# LIBRESSL:
# see https://github.com/gentoo/libressl/wiki/Transition-plan
# summarized: as of 14th October 2015, there are issues with mysql.
# I don't feel like forking it and running exhausive tests and builds,
# also I am not part of any gentoo herd atm, so doing it alone is pointless.
# for mysql we will have to wait for mariadb/mysql/etc to be -libressl'ed.
# postgresql and sqlite and all that other stuff below should work.

REQUIRED_USE="
	!mysql? ( !postgresql? ( sqlite ) )
	!mysql? ( !sqlite? ( postgresql ) )
	!postgresql? ( !mysql? ( sqlite ) )
	!postgresql? ( !sqlite? ( mysql ) )
	!sqlite? ( !postgresql? ( mysql ) )
	!sqlite? ( !mysql? ( postgresql ) )
"
# todo: bluetooth library
RDEPEND="
	>=net-misc/curl-7.21.0
	>=media-libs/libextractor-0.6.1
	>=dev-libs/libgcrypt-1.6
	>=dev-libs/libunistring-0.9.2
	net-misc/gnurl
	sys-libs/ncurses
	sys-libs/zlib
	net-dns/libidn
	ssl? ( >=dev-libs/openssl-1.0 )
	httpd? ( >=net-libs/libmicrohttpd-0.9.42[messages] )
	mysql? ( >=virtual/mysql-5.1 )
	nls? ( sys-devel/gettext )
	postgresql? ( >=dev-db/postgresql-server-8.3 )
	sqlite? ( >=dev-db/sqlite-3.0 )
	dev-libs/gmp
	X? (
		x11-libs/libXt
		x11-libs/libXext
		x11-libs/libX11
		x11-libs/libXrandr
	)
	dane? ( >=net-libs/gnutls-3.1.3[dane] )
	experimental? (
		 dev-libs/jansson
		 conversation? (
						>=media-sound/pulseaudio-2.0
						>=media-libs/opus-1.0.1
						>=media-libs/libogg-1.3.0
					   )
		 qr? ( >=media-gfx/zbar-0.10[python] )
		 tex? ( >=app-text/texlive-2012 )
		 >=sci-mathematics/glpk-4.45
	)
	gui? ( net-misc/gnunet-gtk )
	gnutls? ( >=net-libs/gnutls-3.2.12 )
	sudo? ( app-admin/sudo )
"

#pulseaudio? ( >=media-sound/pulseaudio-2.0 )
#opus? ( >= media-libs/opus-1.0.1 )
#ogg? ( >=media-libs/libogg-1.3.0 )

# for GNS NSS build with --with-sudo
# ./configure --with-sudo=sudo --with-nssdir=/lib

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
	else
		# only needed for gnunet <= 0.10.1
		epatch "${FILESDIR}"/install.diff
	fi
}

# was: ${PF}
# --docdir="${EPREFIX}/usr/share/doc/${PF}" \
src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable experimental) \
		$(use_with httpd microhttpd) \
		$(use_with mysql) \
		$(use_with postgresql) \
		$(use_with sqlite) \
		$(use_with X x) \
		$(use_with gnutls) \
		$(use_with dane) \
		$(use_with ssl)
}
# testing: everything below sudo
#		$(use_with sudo) \
# $(use_with dane) \
# $(use_with pulse) \

# todo: prevent the creation of
# gnunet-$PV AND gnunet + gnunet-gtk-$PV AND gnunet-gtk
# in docs dir

src_install() {
	MAKEOPTS="-j1" emake DESTDIR="${D}" install
	newinitd "${FILESDIR}"/gnunet.initd gnunet
	insinto /etc/gnunet
	doins "${FILESDIR}"/gnunet.conf
	keepdir /var/{lib,log}/gnunet
	fowners gnunet:gnunet /var/lib/gnunet /var/log/gnunet
	dodoc COPYING README
}

# note: we might want to change the agency part, although it's true
# it does not have to sound that paranoid to the user.
# then again, I haven't found a better description.

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
