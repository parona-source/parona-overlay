# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multibuild

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

IUSE="test"
RESTRICT="!test? ( test )"

pkg_setup() {
	MULTIBUILD_VARIANTS=( shared-libs $(usev test) )
}

src_prepare() {
	cmake_src_prepare

	sed -e '/include(cmake\/ftxui_benchmark.cmake)/d' \
		-i CMakeLists.txt || die

}

src_configure() {
	myconfigure() {
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
		if [[ "${MULTIBUILD_VARIANT}" == "test" ]]; then
			mycmakeargs+=(
				-DBUILD_SHARED_LIBS=OFF
				-DFTXUI_BUILD_TESTS=ON
			)
		fi
		cmake_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_test() {
	mytest() {
		if [[ "${MULTIBUILD_VARIANT}" == "test" ]]; then
			cmake_src_test
		fi
	}
	multibuild_foreach_variant mytest
}

src_install() {
	myinstall() {
		if [[ "${MULTIBUILD_VARIANT}" == "shared-libs" ]]; then
			cmake_src_install
		fi
	}
	multibuild_foreach_variant myinstall
}
