# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Qt library for QR code generation and decoding"
HOMEPAGE="https://github.com/bratao/qzxing"
# original upstream: https://projects.developer.nokia.com/QZXing

#autotools?
if [[ "${PV}" == "9999" ]]; then
	inherit eutils qmake-utils git-r3
	EGIT_MIN_CLONE_TYPE="shallow"
	EGIT_REPO_URI="git://github.com/bratao/qzxing"
fi

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

# dependencies: no idea. none?
# XXX: Actually this is broken as of qt-5.7, if anyone feels bothered enough
# to find out which version last worked, pin to it.
RDEPEND=""
DEPEND="${RDEPEND}
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets
		dev-qt/qtdeclarative:5"
# missing?: qt modules named "qml"+"quick" -> this is in qtcore.

src_configure() {
	eqmake5
	default
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
