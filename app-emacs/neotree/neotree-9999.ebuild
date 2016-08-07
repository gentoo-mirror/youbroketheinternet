# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="https://github.com/jaypei/emacs-neotree.git"
EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}"

inherit elisp git-r3

DESCRIPTION="A tree plugin like Nerd Tree for Vim"
HOMEPAGE="https://github.com/jaypei/emacs-neotree"
LICENSE="GPL-3"
SLOT="0"

S="${WORKDIR}/${PN}"
# SITEFILE="50${PN}-gentoo.el"
# ELISP_PATCHES="{P}-vd.patch
DOCS="README.md"
src_install() {
	elisp_src_install
	insinto "${SITEETC}/${PN}"
	doins -r icons
}
pkg_postinst() {
	elisp-site-regen
	elog
	elog "add the following to your emacs configuration file"
	elog "(add-to-list 'load-path \"/some/path/neotree\")"
	elog "(require 'neotree)"
	elog "(global-set-key [f8] 'neotree-toggle)"
	elog "so you can toggle neotree with F8"
	elog
}
pkg_postrm() {
	elisp-site-regen
}
