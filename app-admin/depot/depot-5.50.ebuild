# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="Organize files from various collections into a common structure like /usr/local"
HOMEPAGE="https://www.usenix.org/publications/library/proceedings/lisa93/full_papers/wong.ps"
SRC_URI="http://ftp.andrew.cmu.edu/pub/depot/${P}.tar.gz"

LICENSE="CMU"
SLOT="0"
# apparently needs to be fixed for 64bit!
KEYWORDS="~x86"
IUSE="test"

DOCS=( README )

src_compile() {
    # this code can't handle too parallel make
    emake -j1
}

src_prepare() {
	epatch "${FILESDIR}/build-5.50.patch"
	eapply_user
}

# Barebones install. Feel free to fix up a complete install instead.
src_install() {
	einstalldocs
	dobin cmd/depot/depot
	doman man/man1/depot.1
	doman man/man5/depot.pref.5
	doman man/man5/depot.conf.5
}
