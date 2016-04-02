# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# author: ng0 <Nils Gillmann> <niasterisk@grrlz.net>

#EAPI=6
EAPI=5

inherit user eutils

DESCRIPTION="The Guix Package Manager."
HOMEPAGE="https://guixsd.org"
SRC_URI="mirror://gnu-alpha/${PN}/${P}.tar.gz"
#ftp://alpha.gnu.org/gnu/guix/guix-0.10.0.tar.gz

RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-scheme/guile-2.0.11[networking]
        dev-libs/libgcrypt
		>=dev-db/sqlite-3.0
		app-arch/bzip2
		sys-devel/gcc
		sys-devel/automake
		sys-devel/gettext
		>=net-libs/gnutls-3.3.22-r2[guile]
		"
#FIXME: gcc's g++ with support for the c++11 standard -> works by default in gentoo?
#DONE: dev-scheme/guile-gnutls  -> net-libs/gnutls hardfork to point to the fixed guile2
#FIXME: dev-scheme/guile-json -> package this.
#BEWARE: ABSOLUTELY use guile from this overlay if you don't want to break your system.
#        This is still experimental, but apparently more stable than the bug #355355
#        celebrating its 6th anniversary this year.
#        You will also need to use gnutls from this overlay, which links to guile here.
RDEPEND="${DEPEND}"

pkg_setup() {
		enewgroup guixbuild
		enewuser guixbuilder01 -1 -1 -1 guixbuild
		enewuser guixbuilder02 -1 -1 -1 guixbuild
		enewuser guixbuilder03 -1 -1 -1 guixbuild
		enewuser guixbuilder04 -1 -1 -1 guixbuild
		enewuser guixbuilder05 -1 -1 -1 guixbuild
		enewuser guixbuilder06 -1 -1 -1 guixbuild
		enewuser guixbuilder07 -1 -1 -1 guixbuild
		enewuser guixbuilder08 -1 -1 -1 guixbuild
		enewuser guixbuilder09 -1 -1 -1 guixbuild
		enewuser guixbuilder10 -1 -1 -1 guixbuild
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
}

#FIXME: Write OpenRC startup and config file, merge into master of guix.
#FIXME: Can Shepperd be ported to Gentoo or some Shepperd-to-OpenRC thing 
#       be written to import GuixSD services into Gentoo fully functional.
# FIXME: use upstream directories (/gnu/ and /var/guix/)

pkg_preinst() {
        enewgroup guixbuild
		enewuser guixbuilder01 -1 -1 -1 guixbuild
		enewuser guixbuilder02 -1 -1 -1 guixbuild
		enewuser guixbuilder03 -1 -1 -1 guixbuild
		enewuser guixbuilder04 -1 -1 -1 guixbuild
		enewuser guixbuilder05 -1 -1 -1 guixbuild
		enewuser guixbuilder06 -1 -1 -1 guixbuild
		enewuser guixbuilder07 -1 -1 -1 guixbuild
		enewuser guixbuilder08 -1 -1 -1 guixbuild
		enewuser guixbuilder09 -1 -1 -1 guixbuild
		enewuser guixbuilder10 -1 -1 -1 guixbuild
}

# POSTINSTALL:
# run guix-daemon, systemd:
# cp ~root/.guix-profile/lib/systemd/system/guix-daemon.service /etc/systemd/system/
# systemctl start guix-daemon && systemctl enable guix-daemon

# run guix-daemon, upstart:
# cp ~root/.guix-profile/lib/upstart/system/guix-daemon.conf /etc/init/
# start guix-daemon

# run guix-daemon, openrc:
# TODO

# To use substitutes from hydra.gnu.org or one of its mirrors (see Substitutes), authorize them:
# guix archive --authorize < ~root/.guix-profile/share/guix/hydra.gnu.org.pub
# (or on gentoo??: /usr/share/guix/hydra.gnu.org.pub)

pkg_postinst() {
	einfo "You have to run the following to enable substitutes from"
	einfo "hydra.gnu.org or one of its mirrors:"
	einfo "guix archive --authorize < /usr/share/guix/hydra.gnu.org.pub"
}
