# Copyright © 2016 ng0 <https://n0.is>
# This files is part of the youbroketheinternet overlay, distributed by the
# youbroketheinternet overlay team.
# Distribution under the GPLv3 or later.

EAPI=5

DESCRIPTION="The Nix functional package manager"
HOMEPAGE="https://nixos.org"

SRC_URI="https://nixos.org/releases/${PN}/${P}/${P}.tar.xz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="etc_profile +gc doc ssl libressl"

COMMON_DEPENDS="
app-arch/bzip2
dev-db/sqlite
ssl? (
	   !libressl? ( dev-libs/openssl:0= )
	   libressl? ( dev-libs/libressl:0= )
)
gc? ( dev-libs/boehm-gc )
doc? ( dev-libs/libxml2
	   dev-libs/libxslt
	   app-text/docbook-xsl-stylesheets
	 )
dev-lang/perl
sys-libs/zlib"

DEPEND="${COMMON_DEPENDS}
>=sys-devel/bison-2.6
>=sys-devel/flex-2.5.35
virtual/perl-ExtUtils-ParseXS"

RDEPEND="${COMMON_DEPENDS}
dev-perl/DBD-SQLite
dev-perl/WWW-Curl
dev-perl/DBI
net-misc/curl"

src_configure() {
	econf $(use_enable gc)
}

src_install() {
	default
	if ! use etc_profile; then
		rm "${ED}"/etc/profile.d/nix.sh || die
	fi
}

pkg_postinstall() {
	if ! use etc_profile; then
		ewarn "${EROOT}etc/profile.d/nix.sh was removed (due to USE=-etc_profile)."
		ewarn "Please fix the ebuild by adding nix user/group handling."
	fi
}
