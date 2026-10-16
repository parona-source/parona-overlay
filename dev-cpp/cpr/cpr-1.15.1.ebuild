# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ Requests: Curl for People, a spiritual port of Python Requests"
HOMEPAGE="
	https://docs.libcpr.org/
	https://github.com/libcpr/cpr/
"

MONGOOSE_VER="7.23"

SRC_URI="
	https://github.com/libcpr/cpr/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
	test? (
		https://github.com/cesanta/mongoose/archive/${MONGOOSE_VER}.tar.gz
			-> mongoose-${MONGOOSE_VER}.tar.gz
	)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="boost test"

RESTRICT="test"
PROPERTIES="test_network"

#TODO: other ssl backends
RDEPEND="
	dev-libs/openssl:=
	>=net-misc/curl-8.13[psl(-)]
"
DEPEND="
	${RDEPEND}
	boost? ( >=dev-libs/boost-1.70 )
	test? ( dev-cpp/gtest )
"

src_configure() {
	local mycmakeargs=(
		-DCPR_THREAD_POOL=$(usex boost BOOST_ASIO BUILTIN)
		-DCPR_USE_SYSTEM_GTEST=ON
		-DCPR_USE_SYSTEM_CURL=ON
		-DCPR_USE_SYSTEM_LIB_PSL=ON
		-DCPR_FORCE_OPENSSL_BACKEND=ON
		-DCPR_BUILD_TESTS=$(usex test)
	)
	use test && mycmakeargs+=(
		-DFETCHCONTENT_SOURCE_DIR_MONGOOSE="${WORKDIR}/mongoose-${MONGOOSE_VER}"
	)
	cmake_src_configure
}

src_test() {
	# Flaky tests otherwise
	cmake_src_test -j1 --timeout=10 --repeat until-pass:5
}
