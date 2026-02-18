# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A Qt-based wrapper for various wayland protocols."
HOMEPAGE="https://gitlab.com/desktop-frameworks/wayqt"
SRC_URI="
	https://gitlab.com/desktop-frameworks/wayqt/-/archive/v${PV}/wayqt-v${PV}.tar.bz2
"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64"

RESTRICT="test" # no tests

RDEPEND="
	dev-qt/qtbase:6=[gui,widgets]
	dev-qt/qtwayland:6=
	dev-libs/wayland
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/wayqt-0.3.0-fix-private-headers.patch
	"${FILESDIR}"/wayqt-0.3.0-qt6.10.patch
)

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
