# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )
PYTHON_REQ_USE="sqlite,xml"
DISTUTILS_SINGLE_IMPL=1

inherit gnome2-utils distutils-r1 versionator xdg-utils

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="https://www.gajim.org/"
SRC_URI="https://www.gajim.org/downloads/$(get_version_component_range 1-2)/${P}.tar.bz2"
#https://ftp.gajim.org/plugins_1/plugin_installer.zip -> ${P}-plugin_installer.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="gpg +crypt remote idle jingle keyring networkmanager upnp geoclue spell +webp rst omemo"

COMMON_DEPEND="
	dev-libs/gobject-introspection[cairo,${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]"
DEPEND="${COMMON_DEPEND}
	app-arch/unzip
	>=dev-util/intltool-0.40.1
	virtual/pkgconfig
	>=sys-devel/gettext-0.17-r1"
RDEPEND="${COMMON_DEPEND}
	dev-python/pyasn1[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=dev-python/python-nbxmpp-0.6.6[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/idna[${PYTHON_USEDEP}]
	dev-python/precis-i18n[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
	crypt? ( dev-python/pycryptodome[${PYTHON_USEDEP}] )
	gpg? ( >=dev-python/python-gnupg-0.4.0[${PYTHON_USEDEP}] )
	idle? ( x11-libs/libXScrnSaver )
	remote? (
		>=dev-python/dbus-python-1.2.0[${PYTHON_USEDEP}]
		dev-libs/dbus-glib
	)
	rst? ( dev-python/docutils[${PYTHON_USEDEP}] )
	keyring? ( dev-python/keyring[${PYTHON_USEDEP}] )
	jingle? (
		net-libs/farstream:0.2[introspection]
		media-libs/gstreamer:1.0[introspection]
		media-libs/gst-plugins-base:1.0[introspection]
		media-libs/gst-plugins-ugly:1.0
	)
	networkmanager? ( net-misc/networkmanager[introspection] )
	upnp? ( net-libs/gupnp-igd[introspection] )
	geoclue? ( app-misc/geoclue[introspection] )
	spell? (
		app-text/gspell[introspection]
		app-text/hunspell
	)
	omemo? (
		dev-python/python-axolotl[${PYTHON_USEDEP}]
		dev-python/qrcode[${PYTHON_USEDEP}]
	)
	webp? ( dev-python/pillow[${PYTHON_USEDEP}] )
"

RESTRICT="test"

src_prepare() {
	ewarn "I will not update the Gajim ebuilds in the future since they are"
	ewarn "available in the pzskc383 repo. Please use that instead."

	default

	use spell || eapply "${FILESDIR}/disable-gspell.patch"
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
