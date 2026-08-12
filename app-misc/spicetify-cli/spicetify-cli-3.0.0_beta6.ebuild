# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

MY_PN="cli"
MY_PV="${PV/_beta/-beta.}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Commandline tool to customize Spotify client"
HOMEPAGE="https://spicetify.app/"
SRC_URI="
	https://github.com/spicetify/cli/archive/v${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+=" https://gitlab.com/api/v4/projects/32909921/packages/generic/${PN}/${MY_PV}/${PN}-${MY_PV}-deps.tar.xz"
	SRC_URI+=" https://gitlab.com/api/v4/projects/32909921/packages/generic/${PN}/${MY_PV}/${PN}-${MY_PV}-js.tar.xz"
fi
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0 BSD LGPL-2.1 MIT"
SLOT="0"
#KEYWORDS="~amd64"

# no tests
RESTRICT="test"

RDEPEND+="
	sys-process/procps
	x11-apps/xrdb
	x11-misc/xdg-utils
"
BDEPEND+=" >=dev-lang/go-1.25.0"

INSTALLDIR="/opt/${PN}"

src_compile() {
	ego build -ldflags "-X main.version=${MY_PV}" -o ./spicetify
}

src_install() {
	insinto "${INSTALLDIR}"
	doins -r spicetify CustomApps Extensions Themes jsHelper globals.d.ts css-map.json supported-versions.json
	newbin - spicetify <<-EOF
	#!/usr/bin/env sh
	exec /opt/spicetify-cli/spicetify \$@
	EOF
	fperms +x "${INSTALLDIR}/spicetify"
}

pkg_postinst() {
	elog "Spicetify requires a Spotify install that it can modify."
	elog "To give read and write permissions to everyone on the system to run the following commands as root."
	elog "# chmod a+wr /opt/spotify/spotify-client"
	elog "# chmod a+wr /opt/spotify/spotify-client/Apps -R"
	elog ""
	elog "WARNING: Do not run spicetify as root please"
	elog ""
	elog "Spicetify compatibility is limited to the Spotify versions listed in ${INSTALLDIR}/supported-versions.json"
	elog ""
	elog "Otherwise you can install spotify to a user modifiable location like as a flatpak:"
	elog " https://spicetify.app/docs/advanced-usage/installation#spotify-installed-from-flatpak"
	elog ""
	elog "To install themes see:"
	elog " https://spicetify.app/docs/advanced-usage/themes"
}
