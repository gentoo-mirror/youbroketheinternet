# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Server for Federated Messaging and Chat over PSYC, IRC, XMPP and more"
HOMEPAGE="http://www.psyced.org"
LICENSE="GPL-2"
EGIT_REPO_URI="git://git.psyced.org/git/psyced"

inherit git-r3 user

# providing actual commit hashes protects against man in
# the middle attacks on the way to the git repository.  --lynX
case ${PV} in
"20160211")
	SRC_URI="http://www.${PN}.org/files/${P}.tar.bz2"
    # same as EGIT_COMMIT="e7a194e703b90e47e330dc0e0281b939c741bf75"
	;;
"20160522")
    EGIT_COMMIT="0120646dd2ed210881f2fa385f2bfe69744e41b6"
	;;
*)
	# last seen change
    EGIT_COMMIT="0120646dd2ed210881f2fa385f2bfe69744e41b6"
	;;
esac
# therefore, for security reasons "9999" doesn't actually
# emerge the latest version. please consult 'git log' and
# update the last EGIT_COMMIT to obtain a newer version.
# to obtain the commit of a particular release, execute
# 'git tag', 'git reset --hard <tag>', then 'git log'.

SLOT="1"
KEYWORDS="x86 ~ppc ~sparc ~amd64"
IUSE="debug"

DEPEND="dev-lang/psyclpc"
RDEPEND="${DEPEND}
	dev-lang/perl"
PROVIDE="virtual/jabber-server virtual/irc-server virtual/psyc-server"

#MYS="${WORKDIR}/${CURRENT}/"
#MYS="${WORKDIR}/${S}/"

pkg_setup() {
	enewgroup psyc
	# the only way to start the script thru su is by having a real shell here.
	# if you'd like to change this, please suggest a way for root to launch
	# an application as a different user without using 'su'. thx.  -lynX
	enewuser ${PN} -1 /bin/sh /var/${PN} psyc
	enewuser psyc -1 -1 /opt/${PN} psyc
}

src_unpack() {
	if [[ ${SRC_URI} != "" ]] ; then
		unpack ${A}
		cd ${S}
		einfo "Unpacking data.tar"
		tar xf data.tar || die
		# only for development purposes
#		git pull
		# things we won't need
		rm -rf makefile install.sh local data log erq run INSTALL.txt || die
		# new: makefile needs to be removed or newer portage will
		# automatically run 'make install'
		rm -f world/log world/data world/local world/place || die
		# this used to be necessary with cvs
		chmod -R go-w . || die
	fi
}

src_install() {
	cd ${S}

	dodir /opt/${PN}
	einfo "The ${PN} universe and sandbox is kept in /opt/${PN}"

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
	rm data.tar || die
	doins -r *

	# in the sandbox, where we use them
	dosym ../local /opt/${PN}/world/local
	dosym ../data /opt/${PN}/world/data
	dosym ../log /opt/${PN}/world/log
	# should we put custom places into /var, too?
	# or even into /usr/local/lib/${PN}/place !??
	dosym ../place /opt/${PN}/world/place

	# so we can 'git pull' without being root
	chown -R psyc:psyc ${D}opt/${PN} || die
}

pkg_postinst() {
	elog " "
	elog "Please edit /etc/psyc/${PN}.ini, then execute psyconf"
	elog "as this will generate the init script which you can add"
	elog "to regular service doing 'rc-update add default ${PN}'"
	elog " "
}

pkg_prerm() {
	# since this file was modified by psyconf unmerge will not delete it
	# automatically. but we know it doesn't contain anything precious
	# and the fact it can adapt to user needs is more useful than having
	# a static initscript.
	#
	rm /etc/init.d/psyced || die
	#
	# or even better, let psyconf know about our deinstallation
	#/usr/sbin/psyconf -D
}

