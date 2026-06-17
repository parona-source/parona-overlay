# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ Functional Terminal User Interface"
HOMEPAGE="https://github.com/ArthurSonzogni/FTXUI"
SRC_URI="
	https://github.com/ArthurSonzogni/FTXUI/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"
S="${WORKDIR}/${P^^}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64"

src_prepare() {
	cmake_src_prepare

	sed -i -e '/include(cmake\/ftxui_benchmark.cmake)/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DFTXUI_BUILD_DOCS=OFF
		-DFTXUI_BUILD_EXAMPLES=OFF #todo
		-DFTXUI_BUILD_TESTS=OFF # requires BUILD_SHARED_LIBS=OFF
		-DFTXUI_BUILD_TESTS_FUZZER=OFF
		-DFTXUI_CLANG_TIDY=OFF
		-DFTXUI_DEV_WARNINGS=OFF
		-DFTXUI_ENABLE_CCACHE=OFF
		-DFTXUI_ENABLE_COVERAGE=OFF
		-DFTXUI_ENABLE_INSTALL=ON
		-DFTXUI_QUIET=OFF
	)
	cmake_src_configure
}
