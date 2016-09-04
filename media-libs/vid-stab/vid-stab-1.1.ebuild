# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# This library should be a dependency for
# media-libs/mlt and media-video/transcode
# and by consequence kde-apps/kdenlive		--lynX 2015

EAPI=5

DESCRIPTION="Martius' camera deshaking and video stabilizing library"
HOMEPAGE="http://public.hronoptik.de/vid.stab/"
LICENSE="GPL-2"

inherit cmake-utils git-r3
EGIT_REPO_URI="https://github.com/georgmartius/vid.stab"
# SRC_URI="https://github.com/georgmartius/vid.stab/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI=""

KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
SLOT="0"
DEPEND="dev-lang/perl"

# providing actual commit hashes protects against man in
# the middle attacks on the way to the git repository.	--lynX
case ${PV} in
"0.9")
	# version tagged "before_complex_transforms"
	EGIT_COMMIT="ad08822f16c8e8af27316c8b93b3c5db2799f914"
	# Date:   Tue Jan 22 20:58:59 2013 +0100
	;;
"0.98")
	EGIT_COMMIT="430b4cffeb99e5b789b9c9d9b99ff72b9a5ce3fc"
	# Date:   Sat Jan 4 15:23:56 2014 +0100
	;;
"0.98a")
	EGIT_COMMIT="94a4692bd7dd9a6f5edebc26a50597b3e750e6a7"
	# Date:   Sat Jan 4 22:00:18 2014 +0100
	;;
"1.0")
	EGIT_COMMIT="07693ded9ad66832d83f2621025049a4587e76a0"
	# Date:   Sun Aug 17 11:29:10 2014 +0200
	;;
"1.1")
	EGIT_COMMIT="97c6ae2719faac74687fe409b5a7258eab06b22e"
	# Date:   Fri May 29 22:56:28 2015 +0200
	;;
*)
	# nothing new in over a year
	EGIT_COMMIT="97c6ae2719faac74687fe409b5a7258eab06b22e"
	;;
esac
# therefore, for security reasons "9999" doesn't actually
# emerge the latest version. please consult 'git log' and
# update the last EGIT_COMMIT to obtain a newer version.
# to obtain the commit of a particular release, execute
# 'git tag', 'git reset --hard <tag>', then 'git log'.

src_prepare() {
	case ${PV} in
"0.9")
		cp "${FILESDIR}"/CMakeLists-0.9 CMakeLists.txt
		;;
	esac
}

src_install() {
	cmake-utils_src_install
	exeinto /usr/bin
	doexe "${FILESDIR}"/deshake
}

