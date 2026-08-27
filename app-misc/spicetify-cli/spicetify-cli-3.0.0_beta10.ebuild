# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

CARGO_OPTIONAL=1
GO_OPTIONAL=1
RUST_MIN_VER="1.95"

inherit cargo go-module

MY_PN="cli"
MY_PV="${PV/_beta/-beta.}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Commandline tool to customize Spotify client"
HOMEPAGE="https://spicetify.app/"
SRC_URI="
	https://github.com/spicetify/cli/archive/v${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		rust? (
			${CARGO_CRATE_URIS}
			https://gitlab.com/api/v4/projects/32909921/packages/generic/${PN}/${PV}/${P}-crates.tar.xz
			https://gitlab.com/api/v4/projects/32909921/packages/generic/${PN}/${MY_PV}/${PN}-${MY_PV}-client-payload.tar.xz
		)
		!rust? (
			https://gitlab.com/api/v4/projects/32909921/packages/generic/${PN}/${MY_PV}/${PN}-${MY_PV}-js-wrapper.tar.xz
			https://gitlab.com/api/v4/projects/32909921/packages/generic/${PN}/${MY_PV}/${PN}-${MY_PV}-deps.tar.xz
		)
	"
fi
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
LICENSE+=" rust? ("
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD Boost-1.0 CC0-1.0 CDLA-Permissive-2.0 ISC MIT MPL-2.0
	Unicode-3.0 Unicode-DFS-2016 WTFPL-2 ZLIB BZIP2
"
LICENSE+=" )"
LICENSE+=" !rust? ( Apache-2.0 BSD MIT )"

SLOT="0"
#KEYWORDS="~amd64"

# project is being rebuilt in rust
IUSE="rust"

DEPEND="
	rust? ( app-arch/zstd:= )
"
RDEPEND="
	sys-process/procps
	x11-apps/xrdb
	x11-misc/xdg-utils
	${DEPEND}
"
BDEPEND="
	!rust? ( >=dev-lang/go-1.25.0 )
	rust? ( ${RUST_DEPEND} )
"

QA_FLAGS_IGNORED="usr/bin/"

INSTALLDIR="/opt/${PN}"

src_unpack() {
	if use rust; then
		cargo_src_unpack
	else
		go-module_src_unpack
	fi
}

src_configure() {
	if use rust; then
		export ZSTD_SYS_USE_PKG_CONFIG=1
		pushd rust >/dev/null || die
		cargo_src_configure
		popd >/dev/null || die
	else
		go-module_src_configure
	fi
}

src_compile() {
	if use rust; then
		pushd rust >/dev/null || die
		cargo_src_compile
		popd >/dev/null || die
	else
		ego build -ldflags "-X main.version=${MY_PV}" -o ./spicetify
	fi
}

src_test() {
	if use rust; then
		pushd rust >/dev/null || die
		cargo_src_test
		popd >/dev/null || die
	else
		ego test
	fi
}

src_install() {
	if use rust; then
		dobin rust/$(cargo_target_dir)/spicetify{,-daemon}
	else
		insinto "${INSTALLDIR}"
		doins -r spicetify CustomApps Extensions Themes jsHelper globals.d.ts css-map.json supported-versions.json
		newbin - spicetify <<-EOF
		#!/usr/bin/env sh
		exec /opt/spicetify-cli/spicetify \$@
		EOF
		fperms +x "${INSTALLDIR}/spicetify"
	fi
}

pkg_postinst() {
	elog "Spicetify requires a Spotify install that it can modify."
	elog "To give read and write permissions to everyone on the system to run the following commands as root."
	elog "# chmod a+wr /opt/spotify/spotify-client"
	elog "# chmod a+wr /opt/spotify/spotify-client/Apps -R"
	elog ""
	elog "WARNING: Do not run spicetify as root please"
	elog ""
	if use !rust; then
		elog "Spicetify compatibility is limited to the Spotify versions listed in ${INSTALLDIR}/supported-versions.json"
		elog ""
	fi
	elog "Otherwise you can install spotify to a user modifiable location like as a flatpak:"
	elog " https://spicetify.app/docs/advanced-usage/installation#spotify-installed-from-flatpak"
	elog ""
	elog "To install themes see:"
	elog " https://spicetify.app/docs/advanced-usage/themes"
}
