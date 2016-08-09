# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

#inherit fixheadtails toolchain-funcs
inherit git-r3

DESCRIPTION="A minimalist FIFO and filesystem-based IRC client (codemadness.nl branch)"
HOMEPAGE="http://tools.suckless.org/ii/"
EGIT_REPO_URI="git://git.codemadness.org/ii"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# src_prepare() {
# 	sed -i \
# 		-e "s/CFLAGS      = -g -O0/CFLAGS += /" \
# 		-e "s/LDFLAGS     =/LDFLAGS +=/" \
# 		-e /^LIBS/d \
# 		config.mk || die "sed failed to fix {C,LD}FLAGS"

# 	# enable verbose build
# 	sed -i 's/@${CC}/${CC}/' Makefile || die

# 	ht_fix_file query.sh
# }

src_compile() {
	#	emake CC="$(tc-getCC)"
	default
}

src_install() {
	# dobin ii
	# newbin query.sh ii-query
	# dodoc CHANGES FAQ README
	# doman *.1
	default
}
