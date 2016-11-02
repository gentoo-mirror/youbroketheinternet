# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit font

DESCRIPTION="Un Core Korean TrueType fonts. UnBatang,UnBatangBold,UnDotum,UnDotumBold,UnGraphic,UnGraphicBold,UnPilgi,UnPilgiBold,UnGungseo"
HOMEPAGE="https://klpd.net/"
#https://kldp.net/frs/download.php/4695/un-fonts-core-1.0.2-080608.tar.gz
SRC_URI="https://kldp.net/frs/download.php/4695/${PN}-core-${PV}-080608.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

# isn't it pointless to have a list of architectures for architecture-independent packages?
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 amd64-fbsd sparc-fbsd x86-fbsd"

DEPEND="app-arch/tar
		app-arch/gzip"
FONT_SUFFIX="ttf"
S=${WORKDIR}/${PN}
FONT_S="${S}"
DOCS="COPYING README"

RESTRICT="strip binchecks"
