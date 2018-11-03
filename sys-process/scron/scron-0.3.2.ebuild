# Copyright 1999-2016 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Simple cron daemon"
HOMEPAGE="http://git.2f30.org/scron/"
SRC_URI="http://git.2f30.org/scron/snapshot/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RESTRICT="strip"

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}" install
	newinitd "${FILESDIR}/init-0.3.2" crond
	dodoc README
}
