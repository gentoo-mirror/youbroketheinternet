# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# Thanks pentoo for this ebuild and its eclass...  ;)

EAPI=5

inherit mozilla-addon

MOZ_FILEID="164511"
DESCRIPTION="Firefox extension to display the Exif and IPTC data in local and remote JPEG images."
HOMEPAGE="http://araskin.webs.com/exif/exif.html"
SRC_URI="http://addons.mozilla.org/downloads/file/${MOZ_FILEID} -> ${P}.xpi"

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
