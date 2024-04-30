# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multibuild

DESCRIPTION="QLMDB is a Qt wrapper around the LMDB C library."
HOMEPAGE="https://github.com/mhoeher/qlmdb"
SRC_URI="
	https://github.com/mhoeher/qlmdb/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test +qt5 qt6"
REQUIRED_USE="|| ( qt5 qt6 )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-db/lmdb:=
	qt5? (
		dev-qt/qtcore:5
	)
	qt6? (
		dev-qt/qtbase:6
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules
	test? (
		qt5? (
			dev-qt/qttest:5
		)
	)
"

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt5 Qt5) $(usev qt6 Qt6) )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
			-DQLMDB_QT_VERSIONS=${MULTIBUILD_VARIANT}
			-DQLMDB_USE_SYSTEM_LIBRARIES=ON
			-DQLMDB_WITHOUT_TESTS=$(usex !test)
		)
		cmake_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_test() {
	multibuild_foreach_variant cmake_src_test
}

src_install() {
	multibuild_foreach_variant cmake_src_install
	einstalldocs
}
