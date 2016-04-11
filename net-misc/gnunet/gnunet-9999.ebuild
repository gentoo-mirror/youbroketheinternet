# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
#
# taken from https://338909.bugs.gentoo.org/attachment.cgi?id=381924
# referenced at https://bugs.gentoo.org/show_bug.cgi?id=338909
# merged with 9999 variant from emery overlay
# refined 2015-07 by carlo von lynX of youbroketheinternet.org
# tweaks since 2015-07 by ng0

EAPI=6
#Error opening `/dev/net/tun': No such file or directory
#Fatal: could not initialize tun-interface `vpn-gnunet'  with --removed--

DESCRIPTION="Cryptographic GNU Mesh/Underlay Network Routing Layer"
HOMEPAGE="https://gnunet.org/"
LICENSE="GPL-3"

# eapi 6 banned: autotools-utils
if [[ ${PV} == "9999" ]] ; then
	inherit eutils autotools subversion user
	WANT_AUTOCONF="2.59"
	WANT_AUTOMAKE="1.11"
	WANT_LIBTOOL="2.2"
	AUTOTOOLS_AUTORECONF=1
	SRC_URI=""
	ESVN_REPO_URI="https://gnunet.org/svn/gnunet"
	ESVN_PROJECT="gnunet"
elif [[ ${PV} == "0.10.2_rc1" ]] ; then
	inherit eutils autotools subversion user
	WANT_AUTOCONF="2.59"
	WANT_AUTOMAKE="1.11"
	WANT_LIBTOOL="2.2"
	AUTOTOOLS_AUTORECONF=1
	SRC_URI=""
	ESVN_REPO_URI="https://gnunet.org/svn/gnunet"
	ESVN_PROJECT="gnunet"
	ESVN_REVISION=37011
fi
#else
#	inherit user eutils
#	SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
#fi

AUTOTOOLS_IN_SOURCE_BUILD=1

#https://lists.gnu.org/archive/html/gnunet-developers/2016-04/msg00013.html
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
#RESTRICT="test" -> python-2.7 for tests.
SLOT="0"
IUSE="experimental extra +httpd mysql nls postgresql +sqlite X +gnutls conversation qr tex sudo +ssl +dane"

#if [[ ${PV} != "9999" ]] ; then
#	PATCHES=( "${FILESDIR}"/install.diff )
#fi

REQUIRED_USE="
	!mysql? ( !postgresql? ( sqlite ) )
	!mysql? ( !sqlite? ( postgresql ) )
	!postgresql? ( !mysql? ( sqlite ) )
	!postgresql? ( !sqlite? ( mysql ) )
	!sqlite? ( !postgresql? ( mysql ) )
	!sqlite? ( !mysql? ( postgresql ) )"

RDEPEND="
	>=net-misc/curl-7.21.0
	>=media-libs/libextractor-0.6.1
	>=dev-libs/libgcrypt-1.6
	>=dev-libs/libunistring-0.9.3
	net-misc/gnurl
	gnutls? ( net-libs/gnutls )
	dane? ( net-libs/gnutls[dane] )
	ssl? ( dev-libs/openssl:0= )
	net-dns/libidn
	sys-libs/ncurses:0
	sys-libs/zlib
	httpd? ( >=net-libs/libmicrohttpd-0.9.42[messages] )
	mysql? ( >=virtual/mysql-5.1 )
	nls? ( sys-devel/gettext )
	postgresql? ( >=dev-db/postgresql-8.3:0 )
	sqlite? ( >=dev-db/sqlite-3.0 )
	dev-libs/gmp:0=
	X? (
	   x11-libs/libXt
	   x11-libs/libXext
	   x11-libs/libX11
	   x11-libs/libXrandr
	)
	extra? (
		dev-libs/jansson
		qr? ( >=media-gfx/zbar-0.10[python] )
		tex? ( >=app-text/texlive-2012 )
		>=sci-mathematics/glpk-4.45
		conversation? (
				>=media-sound/pulseaudio-2.0
				>=media-libs/opus-1.0.1
				>=media-libs/libogg-1.3.0
		)
	)
	sudo? ( app-admin/sudo )
	>=dev-lang/python-2.7
"

DEPEND="
	${RDEPEND}
	sys-devel/automake:1.14"

MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	enewgroup gnunetdns
	enewgroup gnunet
	enewuser  gnunet -1 -1 /var/lib/gnunet gnunet
}

src_prepare() {
	subversion_src_prepare
	rm -rf libltdl || die
	eautoreconf
	./contrib/pogen.sh || die
	default
	# if [[ ${PV} == "9999" ]] ; then
	# 	subversion_src_prepare
	# 	rm -rf libltdl || die
	# 	eautoreconf
	# 	./contrib/pogen.sh || die
	# 	default
	# 	#autotools-utils_src_prepare
	# 	#epatch_user
	# else
	# 	default
	# fi
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
		$(use_with gnutls)
}
# debug those:
#$(use_with dane) \
#$(use_with ssl) \
#--with-gnunetdns=gnunetdns

src_install() {
	default
	newinitd "${FILESDIR}/gnunet.initd" gnunet
	insinto /etc/gnunet
	doins "${FILESDIR}/gnunet.conf"
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
	einfo "	    provided in /usr/share/gnunet/hellos or remove them if you"
	einfo "	    want to run GNUnet another way."
	einfo
}
