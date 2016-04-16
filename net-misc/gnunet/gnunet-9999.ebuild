# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
#
# taken from https://338909.bugs.gentoo.org/attachment.cgi?id=381924
# referenced at https://bugs.gentoo.org/show_bug.cgi?id=338909
# merged with 9999 variant from emery overlay
# refined 2015-07 by carlo von lynX of youbroketheinternet.org
# tweaks, complete rewrite since 2015-07 by ng0

EAPI=6

DESCRIPTION="Cryptographic GNU Mesh/Underlay Network Routing Layer"
HOMEPAGE="https://gnunet.org/"
LICENSE="GPL-3"
PYTHON_COMPAT=( python2_7 ) #rest needs to be tested

if [[ "${PV}" == "9999" ]]; then
	inherit eutils autotools subversion user python-any-r1
	ESVN_REPO_URI="https://gnunet.org/svn/gnunet"
	ESVN_PROJECT="gnunet"
	WANT_AUTOCONF="2.59"
	WANT_AUTOMAKE="1.11"
	WANT_LIBTOOL="2.2"
	AUTOTOOLS_AUTORECONF=1
else
	inherit eutils autotools subversion user python-any-r1
	WANT_AUTOCONF="2.59"
	WANT_AUTOMAKE="1.11"
	WANT_LIBTOOL="2.2"
	AUTOTOOLS_AUTORECONF=1
	SRC_URI="mirror://gentoo/${P}.tar.gz
			https://libertad.pw/static/${PN}-${PV}.tar.gz"
	#intended temporary place, also later moved to code.*
	#old/upstream: mirror://gnu/${PN}/${P}.tar.gz
fi
AUTOTOOLS_IN_SOURCE_BUILD=1
KEYWORDS="~amd64"
SLOT="0"
IUSE="+httpd +sqlite postgresql mysql nls nss +X +gnutls +dane +bluetooth ssl experimental extra conversation pulseaudio gstreamer qr tex test"
# With current svn numbers this is no longer needed.
#if [[ ${PV} != "9999" ]] ; then
#	PATCHES=( "${FILESDIR}"/install.diff )
#fi
RESTRICT="test" # how is running tests handled in this case in gentoo?
REQUIRED_USE="?? ( mysql postgresql sqlite )
			  ?? ( pulseaudio gstreamer )"

# note for gentoo-hardened:
# might be possible to build with
# "--with-gcc-hardening" and "--with-linker-hardening"

RDEPEND="
	mysql? ( >=virtual/mysql-5.1 )
	postgresql? ( >=dev-db/postgresql-8.3:= )
	sqlite? ( >=dev-db/sqlite-3.0 )
	>=net-misc/curl-7.21.0
	>=media-libs/libextractor-0.6.1
	>=dev-libs/libgcrypt-1.7
	>=dev-libs/libunistring-0.9.3
	>=net-misc/gnurl-7.34.0
	gnutls? ( net-libs/gnutls )
	dane? ( net-libs/gnutls[dane] )
	ssl? ( dev-libs/openssl:0= )
	net-dns/libidn
	sys-libs/ncurses:0
	sys-libs/zlib
	httpd? ( >=net-libs/libmicrohttpd-0.9.42[messages] )
	nls? ( >=sys-devel/gettext-0.18.1 )
	nss? ( dev-libs/nss )
	dev-libs/gmp:0=
	X? (
	   x11-libs/libXt
	   x11-libs/libXext
	   x11-libs/libX11
	   x11-libs/libXrandr
	)
	dev-libs/jansson
	>=sci-mathematics/glpk-4.43
	extra? (
		qr? ( >=media-gfx/zbar-0.10[python] )
		tex? ( >=app-text/texlive-2012 )
		conversation? (
				gstreamer? (
					   media-libs/gstreamer:1.0
					   dev-libs/glib:2 )
				pulseaudio? ( >=media-sound/pulseaudio-2.0 )
				>=media-libs/opus-1.0.1
				>=media-libs/libogg-1.3.0
		)
	)
	bluetooth? ( net-wireless/bluez )
	test? ( ${PYTHON_DEPS} )"
#test? ( >=dev-lang/python-2.7:2.7 )

DEPEND="
	${RDEPEND}"
	#sys-devel/automake:1.14"

MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	enewgroup gnunet
	enewuser "gnunet" -1 -1 /var/lib/gnunet "gnunet"
	esethome "gnunet" /var/lib/gnunet
}

# Technically it is a svn checkout, just to be sure
# we run what ./bootstrap would do.
src_prepare() {
	if [[ "${PV}" == "9999" ]]; then
		subversion_src_prepare
		rm -rf libltdl || die
		eautoreconf
		./contrib/pogen.sh || die
		default
	else
		rm -rf libltdl || die
		eautoreconf
		./contrib/pogen.sh || die
		default
	fi
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable nls) \
		$(use_enable experimental) \
		$(use_with httpd microhttpd) \
		$(use_with mysql) \
		$(use_with postgresql) \
		$(use_with sqlite) \
		$(use_with X x) \
		$(use_with gnutls) \
		$(use_with bluetooth) \
		--with-libextractor
}
# debug those:
#$(use_with ssl) \

src_install() {
	default
	#newinitd "${FILESDIR}/gnunet.initd" gnunet
	newinitd "${FILESDIR}"/gnunet.initd gnunet
	insinto /etc/gnunet
	doins "${FILESDIR}"/gnunet.conf
	keepdir /var/{lib,log}/gnunet
	fowners gnunet:gnunet /var/lib/gnunet /var/log/gnunet
}

pkg_postinst() {
	einfo "Updating GTK icon cache"
	gtk-update-icon-cache #does not work somehow.
	elog "To configure"
	elog "	 1) Add desired user(s) to the 'gnunet' group"
	elog "	 2) Edit the system-wide config file '/etc/gnunet/gnunet.conf'"
	elog "	    preferably using 'gnunet-setup -c /etc/gnunet/gnunet.conf'"
	elog "	    ('gnunet-setup' is part of the gnunet-gtk package)"
	elog "	 3) You may want to choose other bootstrap nodes than the ones"
	elog "	    provided in /usr/share/gnunet/hellos or remove them if you"
	elog "	    want to run GNUnet another way."
	elog "   4) Certain services will require '/dev/net/tun' to exist,"
	elog "      which you must enable in your kernel."
	elog ""
	elog "   For further troubleshooting and info, take a look at the wiki"
	elog "   page about gnunet."
}
