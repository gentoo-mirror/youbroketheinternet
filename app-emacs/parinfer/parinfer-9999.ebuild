# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp git-r3

DESCRIPTION="Simpler Lisp editing"
HOMEPAGE="https://github.com/DogLooksGood/parinfer-mode"

EGIT_REPO_URI="https://github.com/DogLooksGood/parinfer-mode"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS="README.md NEWS.md"

pkg_postinst() {
	elisp-site-regen
}

pkg_postrm() {
	elisp-site-regen
}
