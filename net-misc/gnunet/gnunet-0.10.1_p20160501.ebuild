# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# taken from https://338909.bugs.gentoo.org/attachment.cgi?id=381924
# referenced at https://bugs.gentoo.org/show_bug.cgi?id=338909
# merged with 9999 variant from emery overlay
# refined 2015-07 by carlo von lynX of youbroketheinternet.org
# complete rewrite by ng0 (collective libertad)

EAPI=6

DESCRIPTION="Cryptographic GNU Mesh/Underlay Network Routing Layer"
HOMEPAGE="https://gnunet.org/"
LICENSE="GPL-3"
PYTHON_COMPAT=( python2_7 ) # tests are not yet python3 compatible.

if [[ "${PV}" == "9999" ]]; then
	inherit eutils autotools subversion user python-any-r1
	ESVN_REPO_URI="https://gnunet.org/svn/gnunet"
	ESVN_PROJECT="gnunet"
	WANT_AUTOCONF="2.59"
	WANT_AUTOMAKE="1.11"
	WANT_LIBTOOL="2.2"
	AUTOTOOLS_AUTORECONF=1
else
	inherit eutils autotools user python-any-r1
	WANT_AUTOCONF="2.59"
	WANT_AUTOMAKE="1.11"
	WANT_LIBTOOL="2.2"
	AUTOTOOLS_AUTORECONF=1
	SRC_URI="mirror://gnu/gnunet/${P}.tar.gz"
fi

S="${WORKDIR}/${PF}/${PN}"

AUTOTOOLS_IN_SOURCE_BUILD=1
KEYWORDS="~amd64"
SLOT="0"
IUSE="+httpd +sqlite postgresql mysql nls nss +X +gnutls +dane +bluetooth ssl experimental extra conversation pulseaudio gstreamer qr tex test hardened"
# Current svn numbers no longer need to be patched.
#if [[ ${PV} != "9999" ]] ; then
#	PATCHES=( "${FILESDIR}"/install.diff )
#fi
RESTRICT="test"
REQUIRED_USE="?? ( mysql postgresql sqlite )
			  ?? ( pulseaudio gstreamer )"

RDEPEND="
	mysql? ( >=virtual/mysql-5.1 )
	postgresql? ( >=dev-db/postgresql-8.3:= )
	sqlite? ( >=dev-db/sqlite-3.0 )
	>=net-misc/curl-7.21.0
	>=media-libs/libextractor-0.6.1
	>=dev-libs/libgcrypt-1.6
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
					   dev-libs/glib:2
				)
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
	enewgroup gnunetdns
	enewgroup gnunet
	enewuser "gnunet" -1 -1 /var/lib/gnunet "gnunet"
	esethome "gnunet" /var/lib/gnunet
}

src_prepare() {
	if [[ "${PV}" == "9999" ]]; then
		subversion_src_prepare
		rm -rf libltdl || die
		eautoreconf
		./contrib/pogen.sh || die
		default
	else
		# run what ./bootstrap would run:
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
	# hardened build (untested)
	use hardened && append-ldflags "--with-gcc-hardening --with-linker-hardening"
}
# debug those:
#$(use_with ssl) \

src_install() {
	default
	newinitd "${FILESDIR}"/gnunet.initd gnunet
	insinto /etc/gnunet
	doins "${FILESDIR}"/gnunet.conf
	keepdir /var/{lib,log}/gnunet
	fowners gnunet:gnunet /var/lib/gnunet /var/log/gnunet
}

pkg_postinst() {
	# We should update the gtk icon cache for the icons.
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
	elog " "
	elog "Optionally, emerge gnunet-gtk to get a GUI for file-sharing and"
	elog "configuration. This is particularly recommended"
	elog "if your network setup is non-trivial, as gnunet-setup can be"
	elog "used to test in the GUI if your network configuration is working."
	elog "gnunet-setup should be run as the \"gnunet\" user under X.  As it"
	elog "does very little with the network, running it as \"root\" is likely"
	elog "also harmless.  You can also run it as a normal user, but then"
	elog "you have to copy \"~/.gnunet/gnunet.conf\" over to the \"gnunet\" user's"
	elog "home directory in the end."
	elog " "
	elog "Once you have configured your peer, run (as the 'gnunet' user)"
	elog "\"gnunet-arm -s\" to start the peer. You can then run the various"
	elog "GNUnet-tools as your \"normal\" user (who should only be in the group 'gnunet')."
}
