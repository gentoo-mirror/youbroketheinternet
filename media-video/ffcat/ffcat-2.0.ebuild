# Distributed under the terms of the Affero GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="symlynX's Fast & Furious Lossless Media Concatenation Tool"

LICENSE="AGPL"
SLOT="0"
DEPEND="dev-lang/perl media-video/gpac media-video/ffmpeg"

# isn't it pointless to have a list of architectures for architecture-independent packages?
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 amd64-fbsd sparc-fbsd x86-fbsd"

S="$WORKDIR"

src_compile() {
	perldoc -o nroff "${FILESDIR}"/${PN} >${PN}.1
}

src_install() {
	exeinto /usr/bin
	doexe "${FILESDIR}"/${PN}
	doman ${PN}.1
}

pkg_postinst() {
	elog "ffcat works best with both media-video/ffmpeg and media-video/gpac installed"
	elog "ffcat also makes use of either media-video/mplayer or media-video/mpv when installed"
}
