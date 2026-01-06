# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake edo flag-o-matic toolchain-funcs unpacker

DESCRIPTION="Open Graph algorithms and Data structure Framework."
HOMEPAGE="
	https://ogdf.uos.de/
	https://github.com/ogdf/ogdf/
"
SRC_URI="
	https://ogdf.uos.de/wp-content/uploads/${PV:0:4}/${PV:5:2}/ogdf.v${PV}.zip
"
S="${WORKDIR}/${PN^^}"

# https://ogdf.uos.de/license/
LICENSE="|| ( GPL-2 GPL-3 ) OGDF-exception"
# Vendored
LICENSE+=" Boost-1.0 BSD-2 EPL-1.0 LGPL-2+ MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="cgal cpu_flags_x86_sse3 test"
RESTRICT="!test? ( test )"

RDEPEND="
	sci-libs/coinor-clp:=
	sci-libs/coinor-utils:=
	cgal? ( sci-mathematics/cgal:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(unpacker_src_uri_depends)
"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use cgal && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use cgal && tc-check-openmp
}

src_prepare() {
	default

	# unbundle by force
	cp "${FILESDIR}"/coin.cmake cmake/coin.cmake || die
	rm -rf src/coin include/coin || die

	cmake_prepare
}

src_configure() {
	# lto-type-mismatch
	filter-lto

	# TODO: configure linear program solver?
	local mycmakeargs=(
		-DDOC_INSTALL=OFF # todo
		-DDOC_INSTALL_DIR:STRING=share/doc/${PF}
		-DOGDF_INCLUDE_CGAL=$(usex cgal)
		-DOGDF_SEPARATE_TESTS=ON
		-DOGDF_SSE3_EXTENSIONS=$(usex cpu_flags_x86_sse3)
		-DOGDF_USE_ASSERT_EXCEPTIONS=OFF # todo: efutils+binutils+libunwind
		-DOGDF_WARNING_ERRORS=OFF
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use test && cmake_build tests
}

src_test() {
	ebegin "Running tests"
	local -a failed_tests=()
	for test in $(find "${BUILD_DIR}/test/bin" -name "test-*"); do
		if ! nonfatal edo ${test}; then
			failed_tests+=( ${test} )
		fi
	done
	eend ${#failed_tests[@]} || die "Failed tests: ${failed_tests[@]}"

}
