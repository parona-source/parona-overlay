# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER=1.70
RUST_OPTIONAL=1
RUST_REQ_USE="rustfmt"

inherit cmake multiprocessing rust

DESCRIPTION="General-purpose cryptographic library maintained by the AWS Cryptography team"
HOMEPAGE="https://github.com/aws/aws-lc"
SRC_URI="
	https://github.com/aws/aws-lc/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		test? (
			https://gitlab.com/api/v4/projects/32909921/packages/generic/${PN}/${PV}/${P}-vendor.tar.xz
		)
	"
fi

LICENSE="Apache-2.0 BSD CC0-1.0 MIT ISC"
SLOT="0" # ABI_VERSION
KEYWORDS="~amd64"

IUSE="rust test tools"

RESTRICT="test !test? ( test )"
PROPERTIES="test_network" # some tests like to test with amazon.com

DEPEND="test? ( kernel_linux? ( sys-libs/libunwind ) )"
BDEPEND="
	dev-lang/go
	dev-lang/perl
	rust? (
		${RUST_DEPEND}
		>=dev-util/bindgen-0.69.5
	)
	test? ( virtual/pkgconfig )
"

pkg_setup() {
	use rust && rust_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DBUILD_LIBSSL=ON
		-DBUILD_TOOL=$(usex tools)
		-DGENERATE_RUST_BINDINGS=$(usex rust)

		# don't conflict with dev-libs/openssl
		-DENABLE_DIST_PKG=ON
		-DENABLE_DIST_PKG_OPENSSL_SHIM=OFF
	)
	cmake_src_configure
}

src_test() {
	if use !tools; then
		# noop test that requires USE="tools"
		mkdir -p "${BUILD_DIR}"/tool-openssl || die
		cat > "${BUILD_DIR}"/tool-openssl/tool_openssl_test <<- EOF || die
		#!/bin/sh
		# Exit code 89 is used for skipped tests, see util/all_tests.go
		exit 89
		EOF
		chmod +x "${BUILD_DIR}"/tool-openssl/tool_openssl_test || die
	fi

	local -x AWS_LC_NUM_TEST_WORKERS="${AWS_LC_NUM_TEST_WORKERS:-$(get_makeopts_jobs)}"
	cmake_build run_tests
}
