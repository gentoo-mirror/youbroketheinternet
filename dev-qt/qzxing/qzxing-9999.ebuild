# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="qzxing"
HOMEPAGE="https://github.com/bratao/qzxing
		  https://projects.developer.nokia.com/QZXing"

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
RDEPEND=""
DEPEND="${RDEPEND}
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets
		dev-qt/qtdeclarative:5"
# missing?: qt modules named "qml"+"quick"

#DOCS=( )

# src_prepare() {
# 	#eautoreconf
# 	eapply_user
# 	default
# }

src_configure() {
	eqmake5
	default
}

# default phase fails:
# * ACCESS DENIED * ACCESS DENIED:  mkdir: /usr/lib64/qt5/qml/QZXing
src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
