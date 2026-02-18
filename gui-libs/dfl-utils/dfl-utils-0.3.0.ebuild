# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="This library provides single-instance Application classes for various utilities."
HOMEPAGE="https://gitlab.com/desktop-frameworks/utils"
SRC_URI="
	https://gitlab.com/desktop-frameworks/utils/-/archive/v${PV}/utils-v${PV}.tar.bz2
		-> dfl-utils-${PV}.tar.bz2
"
S="${WORKDIR}/utils-v${PV}"

LICENSE="GPL-3"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64"

RESTRICT="test" # no tests

RDEPEND="
	dev-qt/qtbase:6
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
