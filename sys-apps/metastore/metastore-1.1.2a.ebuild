# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Store and restore metadata of files, directories, links in a tree"
HOMEPAGE="https://github.com/przemoc/metastore"
EGIT_REPO_URI="https://github.com/przemoc/metastore.git"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE=""
SLOT="0"

case ${PV} in
"1.1.2a")
	EGIT_COMMIT="ee36104279f55c26a0ec71abbe8cccbbd0bc3966"
	;;
*)
	EGIT_COMMIT="ee36104279f55c26a0ec71abbe8cccbbd0bc3966"
	;;
esac

src_install() {
	emake install PREFIX="$D/usr"
}

