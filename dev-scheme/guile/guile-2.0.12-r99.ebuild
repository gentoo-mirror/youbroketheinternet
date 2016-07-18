# Distributed under the terms of the GNU General Public License v2

# 2.0.12 release:
# http://lists.gnu.org/archive/html/info-gnu/2016-07/msg00007.html

EAPI="5"

inherit eutils flag-o-matic

DESCRIPTION="Scheme interpreter. Also The GNU extension language"
HOMEPAGE="https://www.gnu.org/software/guile/"
SRC_URI="mirror://gnu/guile/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="2"
MAJOR="2.0"
KEYWORDS="~"
IUSE="debug debug-malloc +deprecated emacs networking nls +regex static +threads"

RESTRICT="mirror"

RDEPEND="
	!dev-scheme/guile:12

	dev-libs/boehm-gc[threads?]
	dev-libs/gmp:0=
	dev-libs/libltdl:0=
	dev-libs/libunistring:0=
	virtual/libffi
	virtual/libiconv
	virtual/libintl

	emacs? ( virtual/emacs )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	replace-flags -Os -O2
	econf \
		--program-suffix="-${MAJOR}" \
		--infodir="${EPREFIX}"/usr/share/info/guile-${MAJOR} \
		--mandir="${EPREFIX}"/usr/share/info/man/man1/guile-${MAJOR} \
		--disable-error-on-warning \
		--disable-rpath \
		--disable-static \
		--enable-posix \
		--with-modules \
		$(use_enable debug guile-debug) \
		$(use_enable debug-malloc) \
		$(use_enable deprecated) \
		$(use_enable networking) \
		$(use_enable nls) \
		$(use_enable regex) \
		$(use_enable static) \
		$(use_with threads)
}

src_install() {
	einstall infodir="${ED}"/usr/share/info/guile-${MAJOR} || die "install failed"

	dodoc AUTHORS COPYING COPYING.LESSER ChangeLog GUILE-VERSION HACKING LICENSE NEWS README THANKS || die

	# From Novell
	# 	https://bugzilla.novell.com/show_bug.cgi?id=874028#c0
	dodir /usr/share/gdb/auto-load/$(get_libdir)

	mv ${D}/usr/$(get_libdir)/libguile-*-gdb.scm ${D}/usr/share/gdb/auto-load/$(get_libdir)

	# This could be handled by eselect-guile I think:
	mv "${ED}"/usr/share/aclocal/guile.m4 "${ED}"/usr/share/aclocal/guile-${MAJOR}.m4 || die "rename of guile.m4 failed"
}
pkg_postinst() {
	[ "${EROOT}" == "/" ] && pkg_config
	eselect guile update ifunset
}

pkg_postrm() {
	eselect guile update ifunset
}

pkg_config() {
	if has_version dev-scheme/slib; then
		einfo "Registering slib with guile"
		install_slib_for_guile
	fi
}

_pkg_prerm() {
	rm -f "${EROOT}"/usr/share/guile/site/slibcat
}
