# Distributed under the terms of the GNU General Public License v3
# Copyright (c) 2016 ng0

EAPI=5

inherit user eutils

DESCRIPTION="The GNU Guix Package Manager."
HOMEPAGE="https://www.gnu.org/s/guix"
SRC_URI="amd64? ( mirror://gnu-alpha/guix/${P}ary.x86_64-linux.tar.xz )
		 x86? ( mirror://gnu-alpha/guix/${P}ary.i686-linux.tar.xz )
		 mips? ( mirror://gnu-alpha/guix/${P}ary.mips64el-linux.tar.xz )
		 arm? ( mirror://gnu-alpha/guix/${P}ary.armhf-linux.tar.xz )"
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
# Make root's profile available under ~/.guix-profile:
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
	>=net-libs/gnutls-3.3.22-r2[guile]"
#FIXME: gcc's g++ with support for the c++11 standard ?
#FIXME: dev-scheme/guile-json -> package this.
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

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_install() {
	insinto /var
	doins -r var/guix
	insinto /
	doins -r gnu
	#dosym /var/guix/profiles/per-user/root/guix-profile ~root/.guix-profile
	#if use systemd; then
	#		insinto /etc/systemd/system
	#		~root/.guix-profile/lib/systemd/system/guix-daemon.service
	#else
	#		insinto /etc/init.d
	#		$FILESDIR/guix-daemon
	#fi
	###dosym /var/guix/profiles/per-user/root/guix-profile/bin/guix /usr/local/bin/guix
	##dobin /var/guix/profile/per-user/root/guix-profile/bin/guix
	#FIXME: add info pages.
	# mkdir -p /usr/local/bin
	# cd /usr/local/bin
	# ln -s /var/guix/profiles/per-user/root/guix-profile/bin/guix
	# It is also a good idea to make the Info version of this manual available there:
	#mkdir -p /usr/local/share/info
	# cd /usr/local/share/info
	# for i in /var/guix/profiles/per-user/root/guix-profile/share/info/* ;
	# do ln -s $i ; done
	#
	# this finishes root level setup rest see postsetup notes

}

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
	einfo ""
	einfo "You have to consult the GNU Guix manual to finish the setup."
}
