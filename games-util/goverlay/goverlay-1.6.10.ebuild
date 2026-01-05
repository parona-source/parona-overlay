# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LAZARUS_WIDGET=qt6
inherit lazarus xdg

MY_PV="${PV/_p/-}"

DESCRIPTION="Graphical UI to help manage Linux overlays."
HOMEPAGE="https://github.com/benjamimgois/goverlay"
SRC_URI="
	https://github.com/benjamimgois/goverlay/archive/refs/tags/${MY_PV}.tar.gz
		-> ${PN}-${MY_PV}.tar.gz
"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

# tests not applicable downstream
FEATURES="test"

DEPEND="
	x11-libs/libX11
"
RDEPEND="
	${DEPEND}
	app-shells/bash
	gui-apps/pascube
	games-util/mangohud
	media-gfx/vkBasalt
	media-libs/mesa
	sys-apps/iproute2
	|| (
		app-arch/7zip[symlinks(+)]
		app-arch/p7zip
	)
"

QA_FLAGS_IGNORED=".*"

src_prepare() {
	default

	# Disable stripping
	sed -i -e '/<Linking>/,/<\/Linking>/ { /<Debugging>/,/<\/Debugging>/d }' goverlay.lpi || die
}

src_compile() {
	elazbuild goverlay.lpi
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install
	einstalldocs
}
