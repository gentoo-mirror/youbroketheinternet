# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $ interrobang-9999

EAPI=5

inherit flag-o-matic git-2 toolchain-funcs

DESCRIPTION="A tiny launcher menu packing a big bang (syntax)"
HOMEPAGE="http://github.com/TrilbyWhite/interrobang.git"
SRC_URI=""
EGIT_REPO_URI="git://github.com/TrilbyWhite/interrobang.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples percontation"

RESTRICT="strip"

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}
	virtual/pkgconfig"

src_compile() {
	if use percontation ; then
		emake ${PN} percontation PREFIX=/usr
	else
		emake ${PN} PREFIX=/usr
	fi
}

src_install() {
	dobin ${PN}
	if use percontation ; then
		dobin percontation
	fi

	dodoc COPYING
	doman ${PN}.1

	if use examples ; then
		exeinto /usr/share/doc/${PF}/examples
		doexe config
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
