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
IUSE="+symlink_all_targets target_torbrowser target_firefox target_firefox-bin"

# isn't it pointless to have a list of architectures for architecture-independent packages?
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 amd64-fbsd sparc-fbsd x86-fbsd"

## symlink all possible target paths if this is set
#if use symlink_all_targets; then
	MZA_TARGETS="torbrowser firefox firefox-bin"
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
