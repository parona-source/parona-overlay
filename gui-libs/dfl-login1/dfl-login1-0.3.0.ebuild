# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="DFL Login1 class implements a part of the systemd logind dbus protocol."
HOMEPAGE="https://gitlab.com/desktop-frameworks/login1"
SRC_URI="
	https://gitlab.com/desktop-frameworks/login1/-/archive/v${PV}/login1-v${PV}.tar.bz2
		-> dfl-login1-${PV}.tar.bz2
"
S="${WORKDIR}/login1-v${PV}"

LICENSE="GPL-3"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64"

RESTRICT="test" # no tests

RDEPEND="
	dev-qt/qtbase:6[dbus]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Duse_qt_version=qt6
	)
	meson_src_configure
}
src_install() {
	meson_src_install
	einstalldocs
}
