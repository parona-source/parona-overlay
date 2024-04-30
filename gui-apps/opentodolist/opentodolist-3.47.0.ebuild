# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ANDROID_OPENSSL_COMMIT="7f5f34d16040883f7353b3f99bc3fc83ecdc2a4b"
SINGLEAPPLICATION_COMMIT="a3ed916f591c300e97b873fde36863fa37b49fa9"
RAL_JSON_COMMIT="82b0e16427ef64bf3d0179177db4c7eb6f004389"
SYNTAX_HIGHLIGHTING_COMMIT="8c75a1d16256498afd7b3eb3099fd7eb2e4c8254"

inherit cmake xdg

DESCRIPTION="A todo and task managing application, written in Qt and using QML for its UI."
HOMEPAGE="https://opentodolist.rpdev.net/"
SRC_URI="
	https://gitlab.com/rpdev/opentodolist/-/archive/${PV}/opentodolist-${PV}.tar.bz2
	https://gitlab.com/rpdev/android-openssl/-/archive/${ANDROID_OPENSSL_COMMIT}/android-openssl-${ANDROID_OPENSSL_COMMIT}.tar.bz2
	https://github.com/itay-grudev/SingleApplication/archive/${SINGLEAPPLICATION_COMMIT}.tar.gz
		-> SingleApplication-${SINGLEAPPLICATION_COMMIT}.tar.gz
	https://gitlab.com/rpdev/ral-json/-/archive/${RAL_JSON_COMMIT}/ral-json-${RAL_JSON_COMMIT}.tar.bz2
	https://github.com/KDE/syntax-highlighting/archive/${SYNTAX_HIGHLIGHTING_COMMIT}.tar.gz
		-> syntax-highlighting-${SYNTAX_HIGHLIGHTING_COMMIT}.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-db/qlmdb[qt6]
	dev-libs/qtkeychain:=[qt6]
	dev-qt/qtbase:6[concurrent,network,sql,widgets,xml]
	dev-qt/qtdeclarative:6
	dev-qt/qtnetworkauth:6
	dev-qt/qtremoteobjects:6
	net-libs/synqclient[qt6]
"
#kde-frameworks/knotifications:6
#kde-frameworks/syntax-highlighting:6
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
"

src_prepare() {
	mv -T "${WORKDIR}/android-openssl-${ANDROID_OPENSSL_COMMIT}" "${S}/3rdparty/android-openssl" || die
	mv -T "${WORKDIR}/SingleApplication-${SINGLEAPPLICATION_COMMIT}" "${S}/3rdparty/SingleApplication" || die
	mv -T "${WORKDIR}/ral-json-${RAL_JSON_COMMIT}" "${S}/3rdparty/ral-json" || die
	mv -T "${WORKDIR}/syntax-highlighting-${SYNTAX_HIGHLIGHTING_COMMIT}" "${S}/3rdparty/KDE/syntax-highlighting" || die
	rm BuildLinuxInstaller.cmake || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DOPENTODOLIST_FORCE_STATIC_3RD_PARTY_LIBRARIES=ON # :/
		-DOPENTODOLIST_QT_VERSIONS=Qt6 # qt5 broken
		-DOPENTODOLIST_USE_SYSTEM_LIBRARIES=ON
		# cant use kf6 so have to use weird middlestate between kf5 and kf6
		-DOPENTODOLIST_WITH_KNOTIFICATIONS=OFF
		-DOPENTODOLIST_USE_SYSTEM_KF_SYNTAX_HIGHLIGHTING=OFF
	)
	cmake_src_configure
}
