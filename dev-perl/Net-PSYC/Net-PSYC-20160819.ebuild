# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Perl implementation of PSYC protocol plus psycion, remotor, syslog2psyc etc."
HOMEPAGE="http://perlpsyc.cheettyiapsyciew.onion http://perl.psyc.eu http://perlpsyc.pages.de"
LICENSE="GPL-2+ Artistic"
SLOT="0"

# isn't it pointless to have a list of architectures for architecture-independent packages?
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 amd64-fbsd sparc-fbsd x86-fbsd"

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
"20160819")
	EGIT_COMMIT="400a73c07fae072904ab3653082a3431d44ddb7d"
	;;
*)
	# last seen change
	EGIT_COMMIT="400a73c07fae072904ab3653082a3431d44ddb7d"
	# therefore, for security reasons "9999" doesn't actually
	# emerge the latest version. please consult 'git log' and
	# update the last EGIT_COMMIT to obtain a newer version.
	# to obtain the commit of a particular release, execute
	# 'git tag', 'git reset --hard <tag>', then 'git log'.
	;;
esac

# some perl library items used by some scripts.. FIXME
DEPEND="dev-lang/perl
		dev-perl/Curses"
IUSE="rxaudio"
RDEPEND="rxaudio? ( media-sound/rxaudio-bin )"

src_compile() {
	# extra check for cryptographic consistency
	git fsck
	make manuals
	make html
}

src_install() {
	#perl_set_version
	ln -f bin/psyccmd bin/psycplay
	dobin bin/*
	# our code is not dependent on perl version
	#insinto ${VENDOR_LIB}
	insinto /usr/lib/perl5/vendor_perl
	doins -r lib/perl5/*
	dodoc -r *.txt cgi contrib hooks
	insinto /usr/lib/psyc/ion
	doins -r lib/psycion/*
	doman share/man/*/*
	dohtml htdocs/*
}
