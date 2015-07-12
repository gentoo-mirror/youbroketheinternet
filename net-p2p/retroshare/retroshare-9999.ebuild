# Derived from gentoo with ideas from eigenlay.  --lynX
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils gnome2-utils multilib qmake-utils

if [[ ${PV} == 9999 ]]; then
	inherit subversion
	ESVN_REPO_URI="https://svn.code.sf.net/p/retroshare/code/trunk"
	ESVN_BOOTSTRAP="confix --bootstrap"
	ESVN_PROJECT="${PN}"
	: ${KEYWORDS=""}
else
	# SRC_URI="http://dev.gentoo.org/~pinkbyte/distfiles/snapshots/${P}.tar.bz2"
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="P2P private sharing application"
HOMEPAGE="http://retroshare.sourceforge.net"

# pegmarkdown can also be used with MIT
LICENSE="GPL-2 GPL-3 Apache-2.0 LGPL-2.1"
SLOT="0"

# use of server-based cli mode is discouraged as only
# a home server installation protects the privacy of
# your friends. so the default is desktop use.  --lynX
IUSE="-cli +feedreader links-cloud +qt5 +voip"
# in our overlay, useful extensions are activated by
# default. thus the plus.  --lynX

REQUIRED_USE="|| ( cli qt5 )
	feedreader? ( qt5 )
	links-cloud? ( qt5 )
	voip? ( qt5 )"

RDEPEND="
	app-arch/bzip2
	dev-db/sqlcipher
	dev-libs/openssl:0
	gnome-base/libgnome-keyring
	net-libs/libupnp
	sys-libs/zlib
	cli? (
		dev-libs/protobuf
		net-libs/libssh[server]
	)
	feedreader? (
		dev-libs/libxml2
		dev-libs/libxslt
		net-misc/curl
	)
	qt5? (
		x11-libs/libX11
		x11-libs/libXScrnSaver
		dev-qt/designer:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtscript:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
		dev-qt/qtxml:5
	)
	voip? (
		media-libs/speex
	)"
DEPEND="${RDEPEND}
	dev-qt/qtcore:5
	virtual/pkgconfig"

src_prepare() {
	local dir

	sed -i \
		-e "s|/usr/lib/retroshare/extensions/|/usr/$(get_libdir)/${PN}/extensions/|" \
		libretroshare/src/rsserver/rsinit.cc \
		|| die "sed failed"

	rs_src_dirs="libbitdht/src openpgpsdk/src libretroshare/src supportlibs/pegmarkdown"
	use cli && rs_src_dirs="${rs_src_dirs} retroshare-nogui/src"
	use qt5 &&
	{
		rs_src_dirs="${rs_src_dirs} retroshare-gui/src"
		# Patch code to enable empty passphrase
		sed -i -e 's/(ui\.password_input->text()\.length() < 3 || ui\.name_input->text()\.length() < 3 || genLoc\.length() < 3)/(ui.name_input->text().length() < 3 || genLoc.length() < 3)/' "${S}/retroshare-gui/src/gui/GenCertDialog.cpp" || die "Failed patching to disable empty password check"
	}
	use links-cloud && rs_src_dirs="${rs_src_dirs} plugins/LinksCloud"
	use feedreader && rs_src_dirs="${rs_src_dirs} plugins/FeedReader"
	use voip && {
		rs_src_dirs="${rs_src_dirs} plugins/VOIP"
# interesting patch from eigenlay:
#		echo "QT += multimedia mobility" >> "plugins/VOIP/VOIP.pro"
	}

# eigenlay also has "use gxs" for sqlcipher option
	epatch "${FILESDIR}/${PN}-0.6.0-force-sqlcipher.patch"

	epatch_user

	# FIXME: add patch that removes and recompiles prebuilt binaries
	# once after unpack  --lynX
}

src_configure() {
	for dir in ${rs_src_dirs} ; do
		pushd "${S}/${dir}" 2>/dev/null || die
		eqmake5
		popd 2>/dev/null || die
	done
}

src_compile() {
	local dir

	for dir in ${rs_src_dirs} ; do
		emake -C "${dir}"
	done

	unset rs_src_dirs
}

src_install() {
	local i
	local extension_dir="/usr/$(get_libdir)/${PN}/extensions/"

	use cli && dobin retroshare-nogui/src/retroshare-nogui
	use qt5 && {
		dobin retroshare-gui/src/RetroShare
		newicon -s 32 retroshare-gui/src/gui/images/retrosharelogo32.png \
			${PN}.png
		newicon -s 128 retroshare-gui/src/gui/images/retrosharelogo1.png \
			${PN}.png
		make_desktop_entry RetroShare RetroShare ${PN}
	}

	exeinto "${extension_dir}"
	use feedreader && doexe plugins/FeedReader/*.so*
	use links-cloud && doexe plugins/LinksCloud/*.so*
	use voip && doexe plugins/VOIP/*.so*

	insinto /usr/share/RetroShare06
	doins libbitdht/src/bitdht/bdboot.txt

	dodoc README.txt
	make_desktop_entry RetroShare
	for i in 24 48 64 ; do
		doicon -s ${i} "build_scripts/Debian+Ubuntu/data/${i}x${i}/${PN}.png"
	done
	doicon -s 128 "build_scripts/Debian+Ubuntu/data/${PN}.png"
}

pkg_preinst() {
	if [[ "${REPLACING_VERSIONS}" = "0.5*"  ]]; then
		elog "You are upgrading from Retroshare 0.5.* to ${PV}"
		elog "Version 0.6.* is backward-incompatible with 0.5 branch"
		elog "and clients with 0.6.* can not connect to clients that have 0.5.*"
		elog "It's recommended to drop all your configuration and either"
		elog "generate a new certificate or import existing from a backup"
	fi
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	use qt5 && einfo "The GUI executable name is: RetroShare"
	use cli && einfo "The console executable name is: retroshare-cli"
	use links-cloud || use voip &&
	{
		elog "Plugin hashes:"
		elog "$(shasum ${extension_dir}/*.so)"
	}
}

pkg_postrm() {
	gnome2_icon_cache_update
}

