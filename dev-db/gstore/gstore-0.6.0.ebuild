# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Unfinished ebuild.

EAPI=6

DESCRIPTION="A graph-based RDF triple store"
HOMEPAGE="https://github.com/Caesar11/gStore"
SRC_URI="https://github.com/Caesar11/gStore/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/gStore-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc examples libressl ssl test"

src_prepare() {
	echo Nothing to prepare
}

src_compile() {
	echo This will fail... FIXME
	make
}
