# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit mozilla-addon

DESCRIPTION="Circumvention of Cloudflare and other anti-constitutional spy websites"
HOMEPAGE="https://git.schwanenlied.me/yawning/cfc"
SRC_URI="https://people.torproject.org/~yawning/volatile/cfc-20160327/cfc@schwanenlied.me.xpi -> ${P}.xpi"

LICENSE="GPL"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+symlink_all_targets target_torbrowser target_firefox target_firefox-bin"

# symlink all possible target paths if this is set
if use symlink_all_targets; then
	MZA_TARGETS="torbrowser firefox firefox-bin"
else
	use target_torbrowser && MZA_TARGETS+=" torbrowser"
	use target_firefox && MZA_TARGETS+=" firefox"
	use target_firefox-bin && MZA_TARGETS+=" firefox-bin"
fi

RDEPEND="
	!symlink_all_targets? (
		target_torbrowser? ( www-client/torbrowser )
		target_firefox? ( www-client/firefox )
		target_firefox-bin? ( www-client/firefox-bin )
	)"
