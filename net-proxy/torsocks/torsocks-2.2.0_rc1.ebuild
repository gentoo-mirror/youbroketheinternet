# Copyright 2016 ng0 <ng0@we.make.ritual.n0.is>
# Distributed under the terms of the GNU General Public License v3 or later
# Comment: Backport to gentoo overlay. Beware, it is RC, so NOT RELEASED,
# NOT STABLE.

EAPI=5

inherit autotools eutils multilib versionator

MY_PV="$(replace_version_separator 3 -)"
MY_PF="${PN}-${MY_PV}"
S=${WORKDIR}/${MY_PF}

DESCRIPTION="Use most socks-friendly applications with Tor"
HOMEPAGE="https://torproject.org"
# (I guess) With the next version release torsocks tarball will be on dist.torproject.org.
SRC_URI="https://people.torproject.org/~dgoulet/torsocks/torsocks-${MY_PV}.tar.bz2 -> ${MY_PF}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs"

# We do not depend on tor which might be running on a different box
DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "/dist_doc_DATA/s/^/#/" Makefile.am doc/Makefile.am || die

	# # Disable tests requiring network access.
	# sed -i -e '/^\.\/test_dns$/d' tests/test_list || \
	# 	die "failed to disable network tests"

	# Guix sourced patch:
	epatch "${FILESDIR}"/${PN}-dns-test.patch
	epatch_user

	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	#dodoc ChangeLog doc/notes/DEBUG doc/socks/{SOCKS5,socks-extensions.txt}
	# XXX: does Gentoo get the man files?

	#Remove libtool .la files
	cd "${D}"/usr/$(get_libdir)/torsocks || die
	rm -f *.la
}
