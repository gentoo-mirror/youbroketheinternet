# Copyright 1999-2016 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# FIXME: The service is broken. Expect up to 45 minutes on halt/reboot
# -- ng0

EAPI=5
inherit user eutils autotools

DESCRIPTION="The GNU Guix Package Manager."
HOMEPAGE="https://www.gnu.org/s/guix"
SRC_URI="mirror://gnu-alpha/${PN}/${P}.tar.gz"
RESTRICT="bincheck"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~mips ~arm"
IUSE="test"

#FIXME: package dev-scheme/guile-json
DEPEND=">=dev-scheme/guile-2.0.12[networking]
	dev-libs/libgcrypt
	>=dev-db/sqlite-3.0
	app-arch/bzip2
	sys-devel/gcc
	sys-devel/automake
	sys-devel/gettext
	>=net-libs/gnutls-3.3.22-r2[guile]"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup guixbuild
	g=0
	for i in `seq -w 0 9`;
	do
		enewuser guixbld$i -1 -1 /var/empty guixbuild;
		if [ $g == 0 ]; then
			g="guixbld$i"
		else
			g="$g,guixbld$i"
		fi
	done
	# For some strange reason all of the generated
	# user ids need to be listed in /etc/group even though
	# they were created with the correct group. This is a
	# command that patches the /etc/group file accordingly,
	# but it expects perl to be installed. If you don't have
	# perl installed, you have to do this manually. Adding a
	# dependency for this is inappropriate.
	perl -pi~ -e 's/^(guixbuild:\w+:\d+):$/\1:'$g'/' /etc/group
}

src_configure() {
	econf
}

#following 3 added later
src_prepare() {
	default
	eautoreconf
	elibtoolize
}
src_compile() {
	default
}
src_test() {
	emake check
}

src_install() {
	emake install DESTDIR="${D}"
	newinitd "${FILESDIR}"/guix guix
	keepdir /run/guix
	fowners :guixbuild /run/guix

}

# To use substitutes from hydra.gnu.org or one of its mirrors (see Substitutes), authorize them:
# guix archive --authorize < ~root/.guix-profile/share/guix/hydra.gnu.org.pub
# (or on gentoo??: /usr/share/guix/hydra.gnu.org.pub)
pkg_postinst() {
	einfo "Warning, this is a test package, thanks for participating"
	einfo "in trying to get a functional GNU Guix package manager into"
	einfo "Gentoo."
	einfo "You have to run the following to enable substitutes from"
	einfo "hydra.gnu.org or one of its mirrors:"
	einfo "guix archive --authorize < /usr/share/guix/hydra.gnu.org.pub"
	einfo "you can test functionality with:"
	einfo "guix pull ; guix package -i hello"
	einfo ""
	einfo "You also have to keep your system up to date with"
	einfo "guix pull  and the commands needed to update"
	einfo "your profile."
	einfo ""
	einfo "!!! It is required (read: mandatory) to read the"
	einfo "!!! documentation for further understanding."
	einfo "!!! Failing to read the documentation will break your"
	einfo "!!! installed guix.  This is not a package which is"
	einfo "!!! supposed to be upgraded or maintained through Gentoo,"
	einfo "!!! this package was just an entry point."
}
