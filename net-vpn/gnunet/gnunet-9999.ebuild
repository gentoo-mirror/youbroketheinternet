# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Written by, in historic order: vminko, vonlynX, ng0.
# https://gnunet.org/gentoo-build is outdated, please ignore.
#
# taken from https://338909.bugs.gentoo.org/attachment.cgi?id=381924
# referenced at https://bugs.gentoo.org/show_bug.cgi?id=338909
# merged with 9999 variant from emery overlay
# refined 2015-07 by carlo von lynX of youbroketheinternet.org
# tweaks since 2015-07 by ng0 and lynX

EAPI=6

DESCRIPTION="Cryptographic GNU Mesh/Underlay Network Routing Layer"
HOMEPAGE="https://gnunet.org/"
LICENSE="GPL-3"
KEYWORDS="~"
# KEYWORDS="~amd64 ~x86"
SLOT="0"

PYTHON_COMPAT=( python2_7 )
WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.11"
# WANT_LIBTOOL="2.2"
AUTOTOOLS_AUTORECONF=1

# if you're a gnunet developer, you can put a symlink to your local git here:
EGIT_REPO_URI="/usr/local/src/${PN}
    https://gnunet.org/git/${PN}
	https://github.com/gnunet/${PN}
    git://git.gnunet.org/${PN}"

case ${PV} in
"9999")
	inherit autotools git-r3 user python-any-r1 flag-o-matic
	# using latest git. caution:
	# this method is prone to man-in-the-middle attacks
	;;
"0.10.2_rc6")
	inherit autotools git-r3 user python-any-r1 flag-o-matic
    EGIT_COMMIT="45140f0fd3426e9689c6d1e5e758f1b75c450e90"
	;;
"0.10.2_rc5")
	inherit autotools git-r3 user python-any-r1 flag-o-matic
    EGIT_COMMIT="4a92d3943554681ce35e8106ef4f889c7a3bfed3"
	;;
"0.10.2_rc4")
	inherit autotools git-r3 user python-any-r1 flag-o-matic
    EGIT_COMMIT="6bcc73a1cbb1d4a609884762eab1b6de761ad1d9"
	;;
"0.10.1")
	inherit autotools user python-any-r1 flag-o-matic
	SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
	S="${WORKDIR}/${PN}"
	# tests of gnunet <= 0.10.1 are using python 2.7, gnunet HEAD uses python 3.
	;;
esac
#S="${WORKDIR}/${PF}/${PN}"

AUTOTOOLS_IN_SOURCE_BUILD=1

# XXX: There is a false warning about root or sudo required for GNS NSS library
# installation, claiming that it will not be installed if it is missing from the
# build environment. With current HEAD (Aug 28 2016) it seems that sudo is no
# longer needed, neither is root. This warning must be fixed in gnunet.
IUSE="debug +httpd +sqlite postgres mysql nls +nss +X +gnutls dane +bluetooth \
	  ssl libressl experimental extra pulseaudio gstreamer qr tex test \
	  +gnurl +curl curl_ssl_gnutls"

# !!! TODO: Sort run depend, required use, build time use.
REQUIRED_USE="|| ( mysql postgres sqlite )
		?? ( pulseaudio gstreamer )
		experimental? ( || ( extra ) )
		extra? ( || ( experimental ) )"

# XXX: We do not know if libressl is functional here, at least it does build,
# so buildtime is safe, runtime should be too. If you find bugs, get in contact
# with me.
## Helpful notes: https://gnunet.org/bugs/view.php?id=4618#bugnotes
RDEPEND="
	mysql? ( >=virtual/mysql-5.1 )
	postgres? ( >=dev-db/postgresql-8.3:= )
	sqlite? ( >=dev-db/sqlite-3.0 )
	>=media-libs/libextractor-0.6.1
	>=dev-libs/libgcrypt-1.6
	>=dev-libs/libunistring-0.9.3
	curl? (
		gnurl? ( >=net-misc/gnurl-7.50.1 )
		!gnurl? ( >=net-misc/curl-7.50.1[curl_ssl_gnutls] )
	)
	gnutls? ( net-libs/gnutls[tools] )
	dane? ( net-libs/gnutls[dane] )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	net-dns/libidn
	sys-libs/zlib
	httpd? ( >=net-libs/libmicrohttpd-0.9.42[messages] )
	nls? ( >=sys-devel/gettext-0.18.1 )
	nss? (
		dev-libs/nss
		sys-libs/glibc
	)
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
	)
	gstreamer? (
		media-libs/gstreamer:1.0
		dev-libs/glib:2
	)
	pulseaudio? ( >=media-sound/pulseaudio-2.0 )
	>=media-libs/opus-1.0.1
	>=media-libs/libogg-1.3.0
	bluetooth? ( net-wireless/bluez )
	test? ( ${PYTHON_DEPS} )"

DEPEND="${RDEPEND}
	sys-devel/automake:1.14"

# TODO: We should run tests on Gentoo, currently this fails.

# XXX: parallel building fails, run one job only.
MAKEOPTS="-j1"

pkg_setup() {
	export GNUNET_HOME="${GNUNET_HOME:=/var/lib/gnunet}"
	# this does not work, someone fix this.
	export GNUNET_PREFIX="${EPREFIX}/usr/lib"
	enewgroup gnunetdns
	enewgroup gnunet
	enewuser gnunet -1 /bin/sh "${GNUNET_HOME}" gnunet
	mkdir -p "${GNUNET_HOME}/config.d"
	chown gnunet "${GNUNET_HOME}/config.d"
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
		rm -rf libltdl || die
		eautoreconf
		./contrib/pogen.sh || die
		default
		eapply_user
	elif [[ "${PV}" == "9999" ]]; then
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
	./bootstrap
	econf \
		$(use_enable experimental ) \
		$(use_with httpd microhttpd ) \
		$(use_with mysql ) \
		$(use_with postgres postgresql ) \
		$(use_with sqlite ) \
		$(use_with X x ) \
		$(use_with gnutls ) \
		--with-extractor
}
#		$(use_with sudo )


src_install() {
	into /
	use nss && dolib.so src/gns/nss/.libs/libnss_gns*.so*
	emake DESTDIR="${D}" install
	rm -rf ${D}/usr/lib/gnunet/nss
	newinitd "${FILESDIR}/${PN}.initd" gnunet
	insinto /etc
	use nss && doins "${FILESDIR}/nsswitch.conf"
	insinto /etc/gnunet
	doins "${FILESDIR}/gnunet.conf"
	keepdir /var/{lib,log}/gnunet
	fowners gnunet:gnunet /var/lib/gnunet /var/log/gnunet
}

pkg_postinst() {
	# We should update the gtk icon cache for the icons.
	# @TODO: provide average working example config to copy for user.
	# @TODO: point out that exact time is needed currently.
	elog " "
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
