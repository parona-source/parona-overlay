# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic unpacker

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

IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	$(unpacker_src_uri_depends)
"

src_configure() {
	# lto-type-mismatch
	filter-lto

	local mycmakeargs=(
		-DOGDF_SEPARATE_TESTS=OFF
		-DDOC_INSTALL=OFF # todo
		-DOGDF_INCLUDE_CGAL=OFF # todo: cgal + openmp
		-DOGDF_USE_ASSERT_EXCEPTIONS=OFF # todo: efutils+binutils+libunwind
		-DDOC_INSTALL_DIR:STRING=share/doc/${PF}
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use test && cmake_build tests
}

src_test() {
	ebegin "Running tests"
	"${BUILD_DIR}"/tests
	eend ${?} || die "Tests failed"
}
