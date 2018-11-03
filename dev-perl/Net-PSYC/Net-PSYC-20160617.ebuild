# Copyright 1999-2016 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Perl implementation of PSYC protocol plus psycion, remotor, psycmp3 etc."
HOMEPAGE="http://perlpsyc.pages.de"
LICENSE="GPL-2+ Artistic"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"		# anything, really

# our version of eclass/git-r3 supports onion gits:
EGIT_REPO_URI="/usr/local/src/perlpsyc
	   git://git.cheettyiapsyciew.onion/perlpsyc
	   git://git.psyced.org/git/perlpsyc"

inherit git-r3 user
#inherit perl-module

# providing actual commit hashes protects against man in
# the middle attacks on the way to the git repository --
# then again, apparently a 'git fsck' is necessary to
# detect manipulated repositories			--lynX
case ${PV} in
"20160616")
	EGIT_COMMIT="a2108a9e2722413d2841349055401363d741e0a6"
	;;
"20160617")
	EGIT_COMMIT="e39508daad92f49017b10f61009821dd4234fdbc"
	;;
"20160621")
	EGIT_COMMIT="0df372d54b4a4fbfa38a7e5919cd6bb8929f73da"
	;;
"20160624")
	EGIT_COMMIT="17f02ba08a8d829345ee62921fcee8e7e996e8d2"
	;;
"20160701")
	EGIT_COMMIT="a16d49ab9cb0aa969f0ede6e74686ecce5da6fb5"
	;;
# do not use this ebuild for newer versions
# as the src_install has changed
esac

# some perl library items used by some scripts.. FIXME
DEPEND="dev-lang/perl
		dev-perl/TimeDate
		dev-perl/Curses"
IUSE="rxaudio"
RDEPEND="rxaudio? ( media-sound/rxaudio-bin )"

src_compile() {
	# extra check for cryptographic consistency
	git fsck
}

src_install() {
	#perl_set_version
	dobin bin/*
	# our code is not dependent on perl version
	#insinto ${VENDOR_LIB}
	insinto /usr/lib/perl5/vendor_perl
	doins -r lib/perl5/*
	dodoc -r *.txt cgi contrib hooks
	insinto /usr/lib/psyc/ion
	doins -r lib/psycion/*
}
