# Distributed under the terms of the Affero GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="symlynX's Fast & Furious Lossless Media Cutting Tool"
# This was previously called 'mp4cut' until it learned to use ffmpeg
# and therefore became able to edit *any* media in a lossless way.

LICENSE="AGPL"
SLOT="0"
DEPEND="dev-lang/perl media-video/gpac media-video/ffmpeg"

# isn't it pointless to have a list of architectures for architecture-independent packages?
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 amd64-fbsd sparc-fbsd x86-fbsd"

S="$WORKDIR"

src_install() {
	exeinto /usr/bin
	doexe "${FILESDIR}"/${PN}
}

pkg_postinst() {
	elog "ffcut works best with both media-video/ffmpeg and media-video/gpac installed"
	elog "ffcut also makes use of either media-video/mplayer or media-video/mpv when installed"
}
