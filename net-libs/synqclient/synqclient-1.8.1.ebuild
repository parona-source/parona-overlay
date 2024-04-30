# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multibuild

DESCRIPTION="Generic file-based sync library and client for WebDAV and Dropbox for Qt/C++."
HOMEPAGE="https://gitlab.com/rpdev/synqclient"
SRC_URI="
	https://gitlab.com/rpdev/synqclient/-/archive/v${PV}/synqclient-v${PV}.tar.bz2
"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test +qt5 qt6"
REQUIRED_USE="|| ( qt5 qt6 )"
RESTRICT="!test? ( test )"

RDEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		dev-qt/qtsql:5
		dev-qt/qtxml:5
	)
	qt6? (
		dev-qt/qtbase:6[network,sql,xml]
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
			-DSYNQCLIENT_QT_VERSIONS=${MULTIBUILD_VARIANT}
			-DSYNQCLIENT_WITHOUT_TESTS=$(usex !test)
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
