# Copyright 1999-2015 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# Unofficial alpha snapshot using current git HEAD commit hash. --lynX

EAPI=5

inherit git-r3

DESCRIPTION="Libpurple (Pidgin) plugin for using a Telegram account"
HOMEPAGE="https://github.com/majn/${PN}"
SRC_URI=""
EGIT_REPO_URI="${HOMEPAGE}"
EGIT_COMMIT="94dd3be54f3fc3945dbbe54dd9809176b1ec0755"
#
# You should see the following submodule commit hashes when emerging:
#		      tgl/__main__ 624cf5ac27433b9716c224ecaa8f1deee0616f99
#	tgl/tl-parser/__main__ 36bf1902ff3476c75d0b1f42b34a91e944123b3c

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+webp libressl"

DEPEND="net-im/pidgin
		dev-libs/openssl
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
		sys-libs/glibc
		webp? ( media-libs/libwebp )
		"
RDEPEND="${DEPEND}"

src_compile(){
	econf $(use_enable webp) || die "econf failed"
	emake || die "emake failed"
}

src_install(){
	emake DESTDIR="${D}" install
}

