# Quick ebuild for AgensGraph --lynX 2018
EAPI=6

# this ebuild actually creates agens' own version of postgres!
DESCRIPTION="AgensGraph, a transactional graph database based on PostgreSQL"
HOMEPAGE="https://github.com/bitnine-oss/agensgraph"
LICENSE="Apache-2.0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~ppc-macos ~x86-solaris"
SLOT="0"

# if you're a developer, you can put a symlink to your local git here:
EGIT_REPO_URI="/usr/local/src/${PN}
	https://github.com/bitnine-oss/${PN}"

case ${PV} in
"9999")
	inherit autotools git-r3 user flag-o-matic
	# using latest git. caution:
	# this method is prone to man-in-the-middle attacks
	;;
#"1.3.2")
#	inherit autotools git-r3 user flag-o-matic
#   EGIT_COMMIT=""
#	;;
"1.3.1")
	inherit autotools user flag-o-matic
	SRC_URI="https://github.com/bitnine-oss/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
#	S="${WORKDIR}/${PN}"
	;;
esac

AUTOTOOLS_IN_SOURCE_BUILD=1

RDEPEND="
	sys-libs/readline
	sys-libs/zlib"

DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	sys-devel/automake"

