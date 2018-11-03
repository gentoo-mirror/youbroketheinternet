# Copyright 1999-2016 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
#
EAPI=5

inherit user eutils

DESCRIPTION="Historic mp3 playback engine"
HOMEPAGE="https://web.archive.org/web/19981205020307/http://www.xaudio.com/download.html"
SRC_URI="http://mp3.pages.de/files/rxaudio"

LICENSE="Shareware"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
S="${WORKDIR}"

src_install() {
		dobin ../distdir/rxaudio
		dodoc ${FILESDIR}/README
}

