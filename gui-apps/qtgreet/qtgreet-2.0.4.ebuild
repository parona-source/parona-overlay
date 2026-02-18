# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Qt based greeter for greetd"
HOMEPAGE="https://marcusbritanicus.gitlab.io/QtGreet/"
SRC_URI="
	https://gitlab.com/marcusbritanicus/QtGreet/-/archive/v${PV}/QtGreet-v${PV}.tar.bz2
"
S="${WORKDIR}/QtGreet-v${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

# mpv automagic
DEPEND="
	acct-user/greetd
	acct-group/greetd
	dev-qt/qtbase:6[gui,dbus,opengl,widgets]
	gui-libs/dfl-applications:=[qt6(+)]
	gui-libs/dfl-ipc:=[qt6(+)]
	gui-libs/dfl-login1:=[qt6(+)]
	gui-libs/dfl-utils:=[qt6(+)]
	gui-libs/wayqt:=[qt6(+)]
	media-video/mpv:=
"
RDEPEND="${DEPEND}
	gui-apps/wayland-logout
	gui-libs/greetd
"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Duse_qt_version=qt6
		-Dusername=greetd
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	keepdir /var/lib/qtgreet
}
