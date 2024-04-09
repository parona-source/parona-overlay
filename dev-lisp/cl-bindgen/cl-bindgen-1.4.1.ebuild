# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..12} )
inherit distutils-r1

DESCRIPTION="A command line tool and library for generating FFI wrappers for Common Lisp"
HOMEPAGE="https://github.com/sdilts/cl-bindgen"
SRC_URI="
	https://github.com/sdilts/cl-bindgen/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-python/clang-python[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
	)
"

python_test() {
	${EPYTHON} test/run_tests.py || die
}
