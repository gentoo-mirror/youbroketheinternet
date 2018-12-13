# Copyright 2018 ng0 <ng0@n0.is>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="static site generation with sh, find, grep and lowdown"
HOMEPAGE="https://www.romanzolotarev.com/ssg.html"
LICENSE="ISC"
SLOT="0"
KEYWORDS="*"
S="$WORKDIR"

src_install() {
	exeinto /usr/bin
	doexe "${FILESDIR}"/ssg3
}
