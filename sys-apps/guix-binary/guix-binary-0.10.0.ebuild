# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# author: ng0 <Nils Gillmann> <niasterisk@grrlz.net>

#EAPI=6
EAPI=5

inherit user eutils

DESCRIPTION="The Guix Package Manager, binary version."
HOMEPAGE="https://guixsd.org"
SRC_URI="amd64? ( mirror://gnu-alpha/guix/${P}.x86_64-linux.tar.xz )
         x86? ( mirror://gnu-alpha/guix/${P}.i686-linux.tar.xz )
		 mips? ( mirror://gnu-alpha/guix/${P}.mips64el-linux.tar.xz )
		 arm? ( mirror://gnu-alpha/guix/${P}.armhf-linux.tar.xz )"
# ftp://alpha.gnu.org/gnu/guix/guix-binary-0.10.0.x86_64-linux.tar.xz
# ftp://alpha.gnu.org/gnu/guix/guix-binary-0.10.0.i686-linux.tar.xz
# ftp://alpha.gnu.org/gnu/guix/guix-binary-0.10.0.mips64el-linux.tar.xz
# ftp://alpha.gnu.org/gnu/guix/guix-binary-0.10.0.armhf-linux.tar.xz

RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~mips ~arm"
IUSE=""
S="${WORKDIR}"

# setup process...
# As root, run:
# cd /tmp (download directory)
# tar --warning=no-timestamp -xf guix-binary-0.10.0.system.tar.xz
# mv var/guix /var/ && mv gnu /
# Make root’s profile available under ~/.guix-profile:
# ln -sf /var/guix/profiles/per-user/root/guix-profile ~root/.guix-profile
# Create the group and user accounts for build users
# Run the daemon, and set it to automatically start on boot.
# Make the guix command available to other users on the machine, for instance with:
# mkdir -p /usr/local/bin
# cd /usr/local/bin
# ln -s /var/guix/profiles/per-user/root/guix-profile/bin/guix
# It is also a good idea to make the Info version of this manual available there:
# mkdir -p /usr/local/share/info
# cd /usr/local/share/info
# for i in /var/guix/profiles/per-user/root/guix-profile/share/info/* ;
# do ln -s $i ; done
#
# this finishes root level setup rest see postsetup notes

DEPEND="!sys-apps/guix
        >=dev-scheme/guile-2.0.11[networking]
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
		#FIXME: shorten this.
}

src_unpack() {
		unpack ${A}
		cd "${S}"
}

src_install() {
		insinto /var
		doins -r var/guix
		insinto /
		doins -r gnu
		dosym /var/guix/profiles/per-user/root/guix-profile ~root/.guix-profile
		#if use systemd; then
		#		insinto /etc/systemd/system
		#		~root/.guix-profile/lib/systemd/system/guix-daemon.service
		#else
		#		insinto /etc/init.d
		#		$FILESDIR/guix-daemon
		#fi
		#dosym /var/guix/profiles/per-user/root/guix-profile/bin/guix /usr/local/bin/guix
		##dobin /var/guix/profile/per-user/root/guix-profile/bin/guix
		#FIXME: add info pages.
}

#FIXME: Write OpenRC startup and config file, merge into master of guix.
#FIXME: Can Shepperd be ported to Gentoo or some Shepperd-to-OpenRC thing 
#       be written to import GuixSD services into Gentoo fully functional.

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
	einfo "After you started the daemon (for example openrc service) you"
	einfo "can test functionality with:"
	einfo "guix pull ; guix package -i hello"
}
