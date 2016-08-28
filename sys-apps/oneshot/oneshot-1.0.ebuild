# Distributed under the terms of the Affero GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Usability frontend to emerge to keep you from breaking your system"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"

LICENSE="AGPL"
SLOT="0"
DEPEND="sys-apps/portage dev-lang/perl virtual/perl-Term-ANSIColor"

src_install() {
	insinto /usr/sbin
	cp files/oneshot-help "${ED}"/usr/sbin || die
	(chdir "${ED}"/usr/sbin; ./oneshot-help --install; dosbin oneshot-*)
}

