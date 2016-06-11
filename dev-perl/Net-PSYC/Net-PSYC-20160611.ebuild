# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Perl implementation of PSYC protocol plus psycion, remotor, psycmp3 etc."
HOMEPAGE="http://perlpsyc.pages.de"
LICENSE="GPL-2+ Artistic"

# our version of eclass/git-r3 supports onion gits:
EGIT_REPO_URI="git://cheettyiapsyciew.onion/perlpsyc
			   git://git.psyced.org/git/perlpsyc"

# providing actual commit hashes protects against man in
# the middle attacks on the way to the git repository --
# then again, apparently a 'git fsck' is necessary to
# detect manipulated repositories			--lynX
case ${PV} in
"20160611")
	inherit git-r3 user
	EGIT_COMMIT="482ac3b9994de468b61646b25f08ed2244540690"
	;;
# "20160525")
#	inherit user
#	SRC_URI="http://www.${PN}.org/files/${P}.tar.bz2"
#	;;
*)
	inherit git-r3 user
	# last seen change
	EGIT_COMMIT="482ac3b9994de468b61646b25f08ed2244540690"
	# therefore, for security reasons "9999" doesn't actually
	# emerge the latest version. please consult 'git log' and
	# update the last EGIT_COMMIT to obtain a newer version.
	# to obtain the commit of a particular release, execute
	# 'git tag', 'git reset --hard <tag>', then 'git log'.
	;;
esac

SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
# IUSE="debug"

# some perl library items used by some scripts.. FIXME
DEPEND="dev-lang/perl"
# also an optional dependency for rxaudio-bin

src_compile() {
	# extra check for cryptographic consistency
	git fsck
}

src_install() {
	dobin bin/*
	doins -r lib
	dodoc -r README TODO cgi contrib hooks
}

