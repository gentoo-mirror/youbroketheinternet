# Copyright 1999-2016 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3

DESCRIPTION="static git page generator"
HOMEPAGE="http://2f30.org"
EGIT_REPO_URI="git://git.2f30.org/stagit.git"

# MIT/X Consortium License
LICENSE="MIT"
SLOT="0"

RDEPEND=">=dev-libs/libgit2-0.22.3"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply_user
	default
}

src_install() {
	default
}

pkg_postinst() {
	if ! [[ "${REPLACING_VERSIONS}" ]]; then
		elog "Usage"
		elog "-----"
		elog ""
		elog "Make files per repository:"
		elog ""
		elog "$ mkdir -p htmldir && cd htmldir"
		elog "$ stagit path-to-repo"
		elog ""
		elog "Make index file for repositories:"
		elog ""
		elog "$ stagit-index repodir1 repodir2 repodir3 > index.html"
	else
		elog "For a quick start, read the file"
		elog "/usr/local/share/stagit/example.sh"
		elog ""
		elog "things to do manually (once):"
		elog "- copy style.css, logo.png and favicon.png manually, a style.css example"
		elog "is included."
		elog "- write clone url, for example 'git://git.code.org/dir' to the 'url'"
		elog "file for each repo."
		elog ""
		elog "You may want to emerge a http server of your choice."
	fi

}
