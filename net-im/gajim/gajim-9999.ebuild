# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6} )
PYTHON_REQ_USE="sqlite,xml"
DISTUTILS_SINGLE_IMPL=1

inherit git-r3g python-r1 versionator

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="http://www.gajim.org/"
EGIT_REPO_URI="https://dev.gajim.org/gajim/gajim.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
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
	autotools-utils_src_prepare
	python_copy_sources
}

src_configure() {
	configuration() {
		local myeconfargs=(
			$(use_enable nls)
			$(use_with X x)
			--docdir="/usr/share/doc/${PF}"
			--libdir="$(python_get_sitedir)"
			--enable-site-packages
		)
		run_in_build_dir autotools-utils_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	compilation() {
		run_in_build_dir autotools-utils_src_compile
	}
	python_foreach_impl compilation
}

src_test() {
	testing() {
		run_in_build_dir ${PYTHON} test/runtests.py --verbose 3 || die
	}
	python_foreach_impl testing
}

src_install() {
	installation() {
		run_in_build_dir autotools-utils_src_install
		python_optimize
	}
	python_foreach_impl installation

	rm "${ED}/usr/share/doc/${PF}/README.html" || die
	dohtml README.html
}
