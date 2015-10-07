# Distributed under the terms of the GNU General Public License v2
# $Header: $
# 
# Not suitable for chatrooms but certainly better for one-on-one conversations
# than anything that goes through servers.	--lynX 2015
#
# http://youbroketheinternet.org

EAPI=5

DESCRIPTION="End-to-end-encrypted instant messaging UI using Tor hidden services"
HOMEPAGE="https://ricochet.im"
LICENSE="BSD GPL-2"

inherit qmake-utils git-r3
EGIT_REPO_URI="https://github.com/ricochet-im/ricochet"
# SRC_URI="https://github.com/ricochet-im/ricochet/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI=""

KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
SLOT="0"

DEPEND="
	virtual/pkgconfig
	dev-qt/qtcore:5
	dev-qt/qtmultimedia:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtnetwork:5
	dev-qt/linguist-tools:5
	dev-libs/protobuf
	dev-libs/openssl"
RDEPEND="${DEPEND}"

# providing actual commit hashes protects against man in
# the middle attacks on the way to the git repository.	--lynX
case ${PV} in
"1.0.4")
	EGIT_COMMIT="b9b8e63569e698d1d907bd01d8a453eda5a99633"
	# Date:   Mon Sep 1 20:25:56 2014 -0600
	;;
"1.1.0")
	EGIT_COMMIT="d87ca77bdcb887b57aa1963bbebeac66006f42bd"
	# Date:   Mon Apr 6 23:26:14 2015 -0600
	;;
"1.1.1")
	EGIT_COMMIT="3aaf80eeb870f56097537ba65c5ac5cffd9b6e26"
	# Date:   Tue Sep 8 18:18:28 2015 -0600
	;;
*)
	EGIT_COMMIT="d29bb2b45eaa4632be61a2b9f6710549f7fe051e"
	# Date:   Fri Sep 18 17:08:27 2015 -0600
	;;
esac
# therefore, for security reasons "9999" doesn't actually
# emerge the latest version. please consult 'git log' and
# update the last EGIT_COMMIT to obtain a newer version.
# to obtain the commit of a particular release, execute
# 'git tag', 'git reset --hard <tag>', then 'git log'.

src_configure() {
	eqmake5 "DEFINES+=RICOCHET_NO_PORTABLE CONFIG+=release"
}

src_install() {
	dobin "${S}/ricochet"
	doicon -s 48x48 "${S}/icons/ricochet.png"
	doicon -s scalable "${S}/icons/ricochet.svg"
	domenu "${S}/src/ricochet.desktop"
}
