# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#
# psyclpc is a programming language for intense multi-user network applications
# such as psyced. it's a fork of LDMud with some features and many bug fixes.
# we kept it compatible, so you can run a MUD with it, too.

EAPI=6

DESCRIPTION="psycLPC is a multi-user network server programming language"
HOMEPAGE="http://lpc.psyc.eu/"
LICENSE="GPL-2"
EGIT_REPO_URI="git://git.psyced.org/git/psyclpc"

# providing actual commit hashes protects against man in
# the middle attacks on the way to the git repository --
# then again, apparently a 'git fsck' is necessary to
# detect manipulated repositories			--lynX
case ${PV} in
"20121010")
	inherit git-r3 elisp-common
	EGIT_COMMIT="76c91004b366c6e18a72184f7baaada87cebee35"
	;;
"20130927")
	inherit git-r3 elisp-common
	EGIT_COMMIT="727399dbcf4dfc5b94c6b4a6fdc7b46f2c1597c0"
	;;
"20160211")
	inherit git-r3 elisp-common
	EGIT_COMMIT="368f85d527f2ab798faa123fe2b47108f341215e"
	;;
"20160417")
	inherit elisp-common
	# EGIT_COMMIT="b29bdca5a13abfc70c03f0b51aa9df84d491349c"
	SRC_URI="http://www.psyced.org/files/${P}.tar.xz"
	;;
"20160821")
	inherit elisp-common
	# EGIT_COMMIT="27f21a3bf0d140f0d2680c695e8df229b46a814b"
	# last snapshot available via http
	SRC_URI="http://www.psyced.org/files/${P}.tar.xz"
	;;
*)
	inherit git-r3 elisp-common
	# last seen change
	EGIT_COMMIT="27f21a3bf0d140f0d2680c695e8df229b46a814b"
	# therefore, for security reasons "9999" doesn't actually
	# emerge the latest version. please consult 'git log' and
	# update the last EGIT_COMMIT to obtain a newer version.
	# to obtain the commit of a particular release, execute
	# 'git tag', 'git reset --hard <tag>', then 'git log'.
	;;
esac

SLOT="0"
# haven't checked for real..
# but there have been non-gentoo ports to all platforms
KEYWORDS="x86 ~ppc ~amd64"
IUSE="debug ssl libressl static zlib ldap ipv6 mysql postgres berkdb vim-syntax emacs"

#REQUIRED_USE="?? ( mysql postgres berkdb ldap )"
RDEPEND="zlib? ( sys-libs/zlib )
		ldap? ( net-nds/openldap )
		berkdb? ( sys-libs/db:= )
		mysql? ( dev-db/mysql )
		postgres? ( dev-db/postgresql:= )
		ssl? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:0= )
		)
		vim-syntax? ( >=app-editors/vim-core-7 )
		emacs? ( virtual/emacs )"

DEPEND="${RDEPEND}
		net-libs/libpsyc
		>=sys-devel/flex-2.5.4a-r5
		>=sys-devel/bison-1.875
		>=sys-devel/gettext-0.12.1"

#use debug && {
#		RESTRICT="${RESTRICT} nostrip"
#}

MYS="${S}/src"
# MYS="${WORKDIR}/${PN}/src"
DOCS=( ANNOUNCE CHANGELOG-psyclpc FAQ HELP )

src_compile() {
		cd "${MYS}"
#		use berkdb >&/dev/null && myopts="${myopts} --enable-db"
#		use mysql >&/dev/null && myopts="${myopts} --enable-mysql" || myopts="${myopts} --disable-mysql"
#		use postgres >&/dev/null && myopts="${myopts} --enable-pgsql"
#		use ldap >&/dev/null && myopts="${myopts} --enable-ldap"
#		use ipv6 >&/dev/null && myopts="${myopts} --enable-ipv6"
		use zlib && {
			einfo "Compiling ${P} with zlib (MCCP) support."
			myopts="${myopts} --enable-use-mccp"
		}
		use ssl && {
			einfo "Compiling ${P} with SSL support."
			myopts="${myopts} --enable-use-tls=yes"
		}
		use mysql && {
			einfo "Compiling ${P} with mySQL support."
			myopts="${myopts} --enable-use-mysql"
		}
		use postgres && {
			einfo "Compiling ${P} with PostgreSQL support."
			myopts="${myopts} --enable-use-pgsql"
		}
		use debug && {
			append-flags -O -ggdb -DDEBUG
# old:		RESTRICT="${RESTRICT} nostrip"
			myopts="${myopts} --enable-debug"
		}
		# this runs configure
		# choice of settings should be configurable.. TODO
		echo settings/psyced ${myopts}
		settings/psyced ${myopts}
		make all && (cd "util/" && make subs) || die "make failed"
}

src_install () {
		cd "${MYS}"
		dosbin ${PN} && (cd "util/erq/" && dosbin "erq") || die "dosbin failed"
		cd "${MYS}/.."
		#dodoc ANNOUNCE CHANGELOG* FAQ HELP || die (todo: nonfatal)
		doman psyclpc.1 || die
		# maybe we should install etc/lpc.vim?
		use vim-syntax && {
			cd "${MYS}/etc"
			sh lpc.vim || die "unpacking vim script failed"
			insinto /usr/share/vim/vimfiles
			doins -r .vim/*
		}
		use emacs && {
			cd "${MYS}/etc"
			elisp-install ${PN} lpc-mode.el || die "elisp-install failed"
		}
}

pkg_postinst() {
		use emacs && elisp-site-regen
}

pkg_postrm() {
		use emacs && elisp-site-regen
}
