# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="This library provides a thin wrapper around QApplication and the rest."
HOMEPAGE="https://gitlab.com/desktop-frameworks/applications"
SRC_URI="
	https://gitlab.com/desktop-frameworks/applications/-/archive/v${PV}/applications-v${PV}.tar.bz2
		-> dfl-applications-${PV}.tar.bz2
"
S="${WORKDIR}/applications-v${PV}"

LICENSE="GPL-3"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64"

RESTRICT="test" # no tests

RDEPEND="
	gui-libs/dfl-ipc:=[qt6(+)]
	dev-qt/qtbase:6[gui,widgets]
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
