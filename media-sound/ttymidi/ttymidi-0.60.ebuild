# Copyright 1999-2016 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="MIDI for your Serial Devices"
HOMEPAGE="http://www.varal.org/ttymidi/"
LICENSE="GPL-3"

MY_P=ttymidi
S=${WORKDIR}/${MY_P}
SRC_URI="http://www.varal.org/ttymidi/ttymidi.tar.gz"
SLOT="0"

# isn't it pointless to have a list of architectures for architecture-independent packages?
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 amd64-fbsd sparc-fbsd x86-fbsd"

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
		cc src/ttymidi.c -o ttymidi -lasound -lpthread
}

src_install() {
		dobin ttymidi
}

pkg_postinst() {
		elog "You may want to add ttymidi users to the 'tty' group"
}

