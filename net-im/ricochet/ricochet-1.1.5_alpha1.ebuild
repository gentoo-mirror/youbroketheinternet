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
IUSE="debug"
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
"1.1.2")
	EGIT_COMMIT="6cfbcd0c3f6d9a2528c504ec50f287e3eeebe5cb"
	# Date:   Sat Jan 16 15:56:34 2016 -0800
	;;
"1.1.3")
	EGIT_COMMIT="6853e40d19e75dd137be35dea9fe86abdc4199f3"
	# Date:   Sun Oct 9 11:06:00 2016 -0700
	;;
"1.1.4")
	EGIT_COMMIT="36d6582f98b64c309609ef88119ab831421910d8"
	# Date:   Fri Nov 4 16:05:25 2016 -0600
	;;
"1.1.5_alpha1")
	EGIT_COMMIT="2504d9cf402d25b8a774eced39e1896c8c287f32"
	# Date:   Wed Nov 16 16:04:11 2016 -0700
	;;
*)
	EGIT_COMMIT="e13b2401507164271c849719e6dfe7e95b89fc23"
	# wfr committed with special Feb 2, 2017
	;;
esac
# therefore, for security reasons "9999" doesn't actually
# emerge the latest version. please consult 'git log' and
# update the last EGIT_COMMIT to obtain a newer version.
# to obtain the commit of a particular release, execute
# 'git tag', 'git reset --hard <tag>', then 'git log'.

src_configure() {
	use debug && d='CONFIG+=debug' || d='CONFIG+=release'
	eqmake5 DEFINES+=RICOCHET_NO_PORTABLE $d
}

src_install() {
	dobin "${S}/ricochet"
	doicon -s 48x48 "${S}/icons/ricochet.png"
	doicon -s scalable "${S}/icons/ricochet.svg"
	domenu "${S}/src/ricochet.desktop"
	#
	# alternate method:
	#	emake INSTALL_ROOT="${D}" install
}
