# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit user

# Thanks to ng0 for writing this initial ebuild stub.
#
# The main reason to want to install Nix on Gentoo is to have a
# source of trustworthy reproducible binaries so we don't have
# to build every binary ourselves in order to be able to trust
# our system. Ideal to avoid having to compile torbrowser, which
# is supposed to be reproducible.
#
# Well, here's some bad news: Nix apparently makes a distinction
# between "reproducible" and "deterministic" according to the only
# wiki page that mentions the terms:
#
#		https://nixos.org/wiki/GSOC_2015_ideas_list
#
# So far we have not found out which packages from the NixOS store
# are trustworthy, let alone how to get a cryptographic proof.
#
# --symlynX 2016
#
# See also:
# https://github.com/NixOS/nixpkgs/labels/6.topic:%20reproducible%20builds

DESCRIPTION="The Nix functional package manager from NixOS.org"
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
#	if ! use etc_profile; then
#		rm "${ED}"/etc/profile.d/nix.sh || die
#	fi
}

pkg_setup() {
	enewgroup nixbld
	g=0
	for i in `seq -w 0 9`;
	do
		enewuser nixbld$i -1 -1 /var/empty nixbld;
		if [ $g == 0 ]; then
			g="nixbld$i"
		else
			g="$g,nixbld$i"
		fi
	done
	# For some strange reason all of the generated
	# user ids need to be listed in /etc/group even though
	# they were created with the correct group. This is a
	# command that patches the /etc/group file accordingly,
	# but it expects perl to be installed. If you don't have
	# perl installed, you have to do this manually. Adding a
	# dependency for this is inappropriate.
	perl -pi~ -e 's/^(nixbld:\w+:\d+):$/\1:'$g'/' /etc/group
}

pkg_postinst() {
	einfo "Warning, this is a test package, thanks for participating"
	einfo "in trying to get a functional Nix package manager into"
	einfo "Gentoo."
	einfo ""
	einfo "!!! It is required (read: mandatory) to read the"
	einfo "!!! documentation for further understanding."
	einfo "!!! Failing to read the documentation will break your"
	einfo "!!! installed nix.  This is not a package which is"
	einfo "!!! supposed to be upgraded or maintained through Gentoo,"
	einfo "!!! this package was just an entry point."

#	if ! use etc_profile; then
#		ewarn "${EROOT}etc/profile.d/nix.sh was removed (due to USE=-etc_profile)."
#		ewarn "Please fix the ebuild by adding nix user/group handling."
#	fi
	. /etc/profile.d/nix.sh
	# FIXME:
	ewarn "Now you should 'nix-channel --update' but it will fail because"
	ewarn "nix-channel requires the names of the nixbld* users listed in /etc/group!?"
	# nix-channel --update
}

# FIXME:
# openrc script needed for launching the nix-daemon
