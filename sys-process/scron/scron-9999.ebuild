# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit git-r3

DESCRIPTION="Simple cron daemon"
HOMEPAGE="http://git.2f30.org/scron/"
EGIT_REPO_URI="git://git.2f30.org/scron.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	!sys-process/cronbase
"

RESTRICT="strip"

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		MANPREFIX="${PREFIX}/usr/share/man/" \
		install

	newinitd "${FILESDIR}/init-0.3.2" crond

	dodoc README
}

pkg_postinst() {
	elog "You will need to set up /etc/crontab file before running scron."
	elog "For details, please see the scron(1) manual page."
}
