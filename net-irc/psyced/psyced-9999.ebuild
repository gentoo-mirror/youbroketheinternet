# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Server for Federated Messaging and Chat over PSYC, IRC, XMPP and more"
HOMEPAGE="http://www.psyced.org"
LICENSE="GPL-2"
EGIT_REPO_URI="git://git.cheettyiapsyciew.onion/psyced
			   git://git.psyced.org/git/psyced"

# providing actual commit hashes protects against man in
# the middle attacks on the way to the git repository --
# then again, apparently a 'git fsck' is necessary to
# detect manipulated repositories			--lynX
case ${PV} in
	# snapshot-based versions first:
"20160525")
	# same as EGIT_COMMIT="498f12819bfe6ef54e4eeabae8017389f433860a"
	# or git tag psyced-20160525
	inherit user
	SRC_URI="http://www.${PN}.org/files/${P}.tar.bz2"
	#
# >>> Unpacking psyced-20160525.tar.bz2 to /usr/lib/python3.3/site-packages
# why does it unpack the source into a shared library of a wrong language?
	;;
	# git-based versions:
"20160522")
	inherit git-r3 user
	EGIT_COMMIT="0120646dd2ed210881f2fa385f2bfe69744e41b6"
	;;
"20160612")
	inherit git-r3 user
	EGIT_COMMIT="952d09e5f2fb0008b456f672a8b92fc928ef73aa"
	;;
*)
	inherit git-r3 user
	# last seen change
	EGIT_COMMIT="952d09e5f2fb0008b456f672a8b92fc928ef73aa"
	# therefore, for security reasons "9999" doesn't necessarily
	# emerge the latest version. please consult 'git log' and
	# update the last EGIT_COMMIT to obtain a newer version.
	# to obtain the commit of a particular release, execute
	# 'git tag', 'git reset --hard <tag>', then 'git log'.
	;;
esac

SLOT="0"

# isn't it pointless to have a list of architectures for architecture-independent packages?
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 amd64-fbsd sparc-fbsd x86-fbsd"

DEPEND="dev-lang/psyclpc"
RDEPEND="${DEPEND}
	dev-lang/perl"
#PROVIDE="virtual/jabber-server virtual/irc-server virtual/psyc-server"

pkg_setup() {
	enewgroup psyc
	# the only way to start the script thru su is by having a real shell here.
	# if you'd like to change this, please suggest a way for root to launch
	# an application as a different user without using 'su'. thx.  -lynX
	enewuser ${PN} -1 /bin/sh /var/${PN} psyc
	enewuser psyc -1 -1 /opt/${PN} psyc

	# was in src_unpack, but then it would impede git from running...
	if [[ "${SRC_URI}" != "" ]] ; then
		unpack ${A}
		einfo "Unpacking data.tar"
		tar xf data.tar || die
		# things we won't need
		rm -rf makefile install.sh local data log erq run INSTALL.txt || die
		# new: makefile needs to be removed or newer portage will
		# automatically run 'make install'
		rm -f world/log world/data world/local world/place || die
		# this used to be necessary with cvs
		chmod -R go-w . || die
	fi
}

src_compile() {
	echo "Nothing to compile here. We're fine. Thank you."
}

src_install() {
	dodir /opt/${PN}
	einfo "The ${PN} sandbox is kept in /opt/${PN}/world"

	# not sure if what we want we would in fact get
	# by doing dodir *after* insinto thus avoiding
	# that stuff ending up in the emerge db
	dodir /var/${PN}
	dodir /var/${PN}/data
	dodir /var/${PN}/data/person
	dodir /var/${PN}/data/place
	keepdir /var/${PN}/data/person
	keepdir /var/${PN}/data/place
	dodir /var/${PN}/config
	chmod -x config/blueprint/*.* || die
	cp -rp config/blueprint/README config/blueprint/*.* "${D}var/${PN}/config" || die
	# also the config is chowned as the webconfigure likes to edit local.h
	chown -R ${PN}:psyc "${D}var/${PN}" || die
	einfo "Person, place and configuration data is kept in /var/${PN}"

	dodir /var/log/${PN}
	dodir /var/log/${PN}/place
	keepdir /var/log/${PN}/place
	chown -R ${PN}:psyc "${D}var/log/${PN}" || die
	einfo "Logs will be written to /var/log/${PN}"

	dodir /etc/psyc
	insinto /etc/psyc
	#doins ${FILESDIR}/${PN}.ini
	doins config/${PN}.ini
	# dispatch-conf or etc-update will handle any collisions

	cat <<X >.initscript
echo "${PN} isn't configured yet. Please go into /etc/psyc."
echo "Have you seen ${HOMEPAGE} already? It's nice."
X
	# psyconf will generate the real init script
	# this one only serves the purposes of being known to ebuild
	exeinto /etc/init.d; newexe .initscript ${PN}
	rm .initscript || die

	(cd "${S}/bin" && dosbin "psyconf") || die "dosbin failed"

	# where we find them
	dosym ../../var/log/${PN} /opt/${PN}/log
	dosym ../../var/${PN}/data /opt/${PN}/data
	dosym ../../var/${PN}/config /opt/${PN}/local

	insinto /opt/${PN}
	if [[ "${SRC_URI}" != "" ]] ; then
		rm data.tar || die
	fi
	doins -r *

	# in the sandbox, where we use them
	dosym ../local /opt/${PN}/world/local
	dosym ../data /opt/${PN}/world/data
	dosym ../log /opt/${PN}/world/log
	# should we put custom places into /var, too?
	# or even into /usr/local/lib/${PN}/place !??
	dosym ../place /opt/${PN}/world/place

	# so we can 'git pull' without being root
	chown -R psyc:psyc "${D}opt/${PN}" || die
}

pkg_postinst() {
	elog " "
	elog "Please edit /etc/psyc/${PN}.ini, then execute psyconf"
	elog "as this will generate the init script which you can add"
	elog "to regular service doing 'rc-update add default ${PN}'"
	elog " "
}

pkg_prerm() {
	# since these file were generated by psyconf, unmerge will not delete them
	# automatically. but we know they do not contain anything valuable and the
	# fact they can adapt to user needs is more useful than having them static.
	# let's not die if the user didn't run psyconf in the first place...
	#
	rm -f /etc/init.d/psyced /opt/psyced/bin/psyced* /opt/psyced/etc/init.d/psyced* /opt/psyced/etc/tor/torrc*
	#
	# or even better, let psyconf know about our deinstallation
	#/usr/sbin/psyconf -D
	# 
	# also let's remove symlinks that we know aren't used by anything else
	# otherwise unmerge will search the entire system for other users
	#
	rm /opt/psyced/data /opt/psyced/local /opt/psyced/log /opt/psyced/world/data /opt/psyced/world/local /opt/psyced/world/log || die
}
