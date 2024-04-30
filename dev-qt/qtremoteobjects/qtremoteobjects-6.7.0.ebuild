# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Qt distributed object system"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

RDEPEND="
	~dev-qt/qtbase-${PV}:6[concurrent,gui,network,widgets]
	~dev-qt/qtconnectivity-${PV}:6[bluetooth]
	~dev-qt/qtdeclarative-${PV}:6
"
DEPEND="${RDEPEND}"

CMAKE_SKIP_TESTS=(
	# network
	tst_ro_reconnect
	tst_integration_external
	tst_proxy_multiprocess
	#FAIL!  : tst_usertypes::extraPropertyInQml() Compared values are not the same
	#  Actual   (obj->property("result").value<int>()): 6
	#  Expected (10)                                  : 10
	#tst_usertypes # Clang+libcxx(?)
	# ???
	tst_integration_multiprocess # Clang+libcxx(?)
	# flaky
	tst_modelview
	tst_ro_signature
)
