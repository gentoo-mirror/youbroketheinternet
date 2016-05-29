# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit mozilla-addon

DESCRIPTION="Monitor and compare certificates your application adopts for encrypted HTTPS web sites"
HOMEPAGE="http://patrol.psyced.org/"
SRC_URI="https://addons.mozilla.org/firefox/downloads/file/134629/certificate_patrol-2.0.14-tb+sb+fx+sm.xpi?src=PSYC -> ${P}.xpi"

LICENSE="MPL-1.1"
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
