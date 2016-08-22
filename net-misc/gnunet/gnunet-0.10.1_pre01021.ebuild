# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Coypright © 2016 ng0

EAPI=6

DESCRIPTION="Cryptographic GNU Mesh/Underlay Network Routing Layer"
HOMEPAGE="https://gnunet.org/"
LICENSE="GPL-3"
PYTHON_COMPAT=( python2_7 ) # tests are not yet python3 compatible.

case ${PV} in
"0.10.1_pre01021")
	inherit autotools subversion user python-any-r1 flag-o-matic
	ESVN_REPO_URI="https://gnunet.org/svn/gnunet"
	ESVN_PROJECT="gnunet"
	ESVN_REVISION="37273"
	WANT_AUTOCONF="2.5"
	WANT_AUTOMAKE="1.11"
	WANT_LIBTOOL="2.2"
	AUTOTOOLS_AUTORECONF=1
	S="${WORKDIR}/${PN}"
	;;
"9999")
	inherit autotools subversion user python-any-r1 flag-o-matic
	ESVN_REPO_URI="https://gnunet.org/svn/gnunet"
	ESVN_PROJECT="gnunet"
	WANT_AUTOCONF="2.5"
	WANT_AUTOMAKE="1.11"
	WANT_LIBTOOL="2.2"
	AUTOTOOLS_AUTORECONF=1
	S="${WORKDIR}/${PN}"
	;;
"0.10.1")
	inherit autotools user python-any-r1 flag-o-matic
	SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
	S="${WORKDIR}/${PN}"
	;;
*)
esac
#S="${WORKDIR}/${PF}/${PN}"

AUTOTOOLS_IN_SOURCE_BUILD=1

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

SLOT="0"
IUSE="debug +httpd +sqlite postgres mysql nls nss +X +gnutls dane +bluetooth ssl libressl experimental extra conversation \
	pulseaudio gstreamer qr tex test +sudo +gnurl +curl curl_ssl_gnutls"
REQUIRED_USE="?? ( mysql postgres sqlite )
		?? ( pulseaudio gstreamer )
		experimental? ( || ( extra ) )
		extra? ( || ( experimental ) )"

RDEPEND="
	mysql? ( >=virtual/mysql-5.1 )
	postgres? ( >=dev-db/postgresql-8.3:= )
	sqlite? ( >=dev-db/sqlite-3.0 )
	>=media-libs/libextractor-0.6.1
	>=dev-libs/libgcrypt-1.6
	>=dev-libs/libunistring-0.9.3
	curl? (
		gnurl? ( >=net-misc/gnurl-7.45.0 )
		!gnurl? ( >=net-misc/curl-7.21.0[curl_ssl_gnutls] )
	)
	gnutls? ( net-libs/gnutls )
	dane? ( net-libs/gnutls[dane] )
	ssl? (
		!libressl? ( dev-libs/openssl:0=  )
		libressl? ( dev-libs/libressl:0=  )
	)
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
	test? ( ${PYTHON_DEPS} )
	sudo? ( app-admin/sudo )"
#test? ( >=dev-lang/python-2.7:2.7 )

DEPEND="${RDEPEND}
	sys-devel/automake:1.14"

MAKEOPTS="-j1"

pkg_setup() {
	export GNUNET_HOME="${GNUNET_HOME:=/var/lib/gnunet}"
	# this does not work, someone fix this.
	export GNUNET_PREFIX="${EPREFIX}/usr/lib"
	enewgroup gnunetdns
	enewgroup gnunet
	enewuser gnunet -1 /bin/sh "${GNUNET_HOME}" gnunet
	if [[ $(egethome gnunet) != ${GNUNET_HOME} ]]; then
		ewarn "For homedir different from"
		ewarn "/var/lib/gnunet set GNUNET_HOME in your make.conf"
		ewarn "and re-emerge."
		esethome gnunet "${GNUNET_HOME}"
	fi
}

# Here we add and run what bootstrap would do.
src_prepare() {
	if [[ "${PV}" == "0.10.1_pre01021" ]]; then
		#subversion_src_prepare
		rm -rf libltdl || die
		eautoreconf
		./contrib/pogen.sh || die
		default
		eapply_user
	elif [[ "${PV}" == "9999" ]]; then
		#subversion_src_prepare
		rm -rf libltdl || die
		eautoreconf
		./contrib/pogen.sh || die
		default
		eapply_user
	else
		default
		eapply_user
	fi
}

src_configure() {
	econf \
		$(use_enable experimental ) \
		$(use_with httpd microhttpd ) \
		$(use_with mysql ) \
		$(use_with postgres ) \
		$(use_with sqlite ) \
		$(use_with X x ) \
		$(use_with gnutls ) \
		--with-extractor \
		$(use_with sudo )
}

src_install() {
	emake DESTDIR="${D}" install
	newinitd "${FILESDIR}/${PN}.initd" gnunet
	insinto /etc/gnunet
	doins "${FILESDIR}/gnunet.conf"
	keepdir /var/{lib,log}/gnunet
	fowners gnunet:gnunet /var/lib/gnunet /var/log/gnunet
}

pkg_postinst() {
	# We should update the gtk icon cache for the icons.
	# @TODO: provide average working example config to copy for user.
	# @TOO: point out that exact time is needed currently.
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
	elog " "
	elog "Please emerge a network time protocol daemon or use other means to keep accurate"
	elog "time on your device, otherwise you might experience problems."
}

pkg_postrm() {
	elog " "
	elog "You have to manually remove the previously created gnunet user"
	elog "and the gnunet + gnunetdns groups."
	elog " "
}
