# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit mozilla-addon

DESCRIPTION="Circumvention of Cloudflare and other anti-constitutional spy websites"
HOMEPAGE="https://git.schwanenlied.me/yawning/cfc"
SRC_URI="https://people.torproject.org/~yawning/volatile/cfc-20160327/cfc@schwanenlied.me.xpi -> ${P}.xpi"

LICENSE="GPL"
SLOT="0"
IUSE="+symlink_all_targets target_torbrowser target_firefox target_firefox-bin"

# isn't it pointless to have a list of architectures for architecture-independent packages?
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 amd64-fbsd sparc-fbsd x86-fbsd"

# gentoo broke global use of use()
MZA_TARGETS="torbrowser firefox firefox-bin"

## symlink all possible target paths if this is set
#if use symlink_all_targets; then
#	MZA_TARGETS="torbrowser firefox firefox-bin"
#else
#	use target_torbrowser && MZA_TARGETS+=" torbrowser"
#	use target_firefox && MZA_TARGETS+=" firefox"
#	use target_firefox-bin && MZA_TARGETS+=" firefox-bin"
#fi

RDEPEND="
	!symlink_all_targets? (
		target_torbrowser? ( www-client/torbrowser )
		target_firefox? ( www-client/firefox )
		target_firefox-bin? ( www-client/firefox-bin )
	)"
