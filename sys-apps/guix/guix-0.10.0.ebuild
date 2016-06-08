# Distributed under the terms of the GNU General Public License v3
# author: <Nils Gillmann> <--removed-->
# further changes by ng0

EAPI=5
inherit user eutils

DESCRIPTION="The Guix Package Manager."
HOMEPAGE="https://guixsd.org"
SRC_URI="mirror://gnu-alpha/${PN}/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~mips ~arm"
IUSE=""

#FIXME: gcc's g++ with support for the c++11 standard ?
#FIXME: package dev-scheme/guile-json
#BEWARE: ABSOLUTELY use guile from this overlay if
#        you don't want to break your system.
#        This is still experimental, but apparently
#        more stable than the bug #355355
#        celebrating its 6th anniversary this year.
#        You will also need to use gnutls from this overlay,
#        which links to guile here.
DEPEND=">=dev-scheme/guile-2.0.11[networking]
		dev-libs/libgcrypt
	>=dev-db/sqlite-3.0
	app-arch/bzip2
	sys-devel/gcc
	sys-devel/automake
	sys-devel/gettext
	>=net-libs/gnutls-3.3.22-r2[guile]"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup guixbuild
	enewuser guixbuilder01 -1 -1 -1 guixbuild
	enewuser guixbuilder02 -1 -1 -1 guixbuild
	enewuser guixbuilder03 -1 -1 -1 guixbuild
	enewuser guixbuilder04 -1 -1 -1 guixbuild
	enewuser guixbuilder05 -1 -1 -1 guixbuild
	enewuser guixbuilder06 -1 -1 -1 guixbuild
	enewuser guixbuilder07 -1 -1 -1 guixbuild
	enewuser guixbuilder08 -1 -1 -1 guixbuild
	enewuser guixbuilder09 -1 -1 -1 guixbuild
	enewuser guixbuilder10 -1 -1 -1 guixbuild
}

src_configure() {
	econf
}

#following 3 added later
src_prepare() {
	default
	eautoreconf
	elibtoolize
}
src_compile() {
	default
}
src_test() {
	emake check
}

src_install() {
	emake install DESTDIR="${D}"
	insinto /etc/init.d
	"${FILESDIR}"/guix
}

#FIXME: Merge OpenRC startup file into guix master
#FIXME: Either Shepperd on Gentoo or Shepperd to OpenRC import.
# FIXME: use upstream directories, not this mess we have now.
pkg_preinst() {
		enewgroup guixbuild
	enewuser guixbuilder01 -1 -1 -1 guixbuild
	enewuser guixbuilder02 -1 -1 -1 guixbuild
	enewuser guixbuilder03 -1 -1 -1 guixbuild
	enewuser guixbuilder04 -1 -1 -1 guixbuild
	enewuser guixbuilder05 -1 -1 -1 guixbuild
	enewuser guixbuilder06 -1 -1 -1 guixbuild
	enewuser guixbuilder07 -1 -1 -1 guixbuild
	enewuser guixbuilder08 -1 -1 -1 guixbuild
	enewuser guixbuilder09 -1 -1 -1 guixbuild
	enewuser guixbuilder10 -1 -1 -1 guixbuild
}

# To use substitutes from hydra.gnu.org or one of its mirrors (see Substitutes), authorize them:
# guix archive --authorize < ~root/.guix-profile/share/guix/hydra.gnu.org.pub
# (or on gentoo??: /usr/share/guix/hydra.gnu.org.pub)
pkg_postinst() {
	einfo "Warning, this is a test package, thanks for participating"
	einfo "in trying to get a functional Guix package manager into"
	einfo "gentoo. please provide us with logs and ideas."
	einfo "You have to run the following to enable substitutes from"
	einfo "hydra.gnu.org or one of its mirrors:"
	einfo "guix archive --authorize < /usr/share/guix/hydra.gnu.org.pub"
	einfo "you can test functionality with:"
	einfo "guix pull ; guix package -i hello"
}
