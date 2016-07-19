# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3
DESCRIPTION="Manage multiple Guile versions on one system"
#HOMEPAGE=""
#There is no homepage at the moment.
EGIT_REPO_URI="git://git.far37qbrwiredyo5.onion:/eselect-guile.git
			   https://git.n0.is/eselect-guile.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"

# Versions prior to guile-1.8.8-r2 aren't properly slotted
DEPEND=""
RDEPEND=">=app-admin/eselect-1.2.6
	!<dev-scheme/guile-1.8.8-r3"

# We don't have any source directory to work on.
S="${T}"

src_install() {
	insinto /usr/share/eselect/modules
	doins guile.eselect
}

pkg_prerm() {
	# Cleanup remaining symlinks
	eselect guile clean
}
