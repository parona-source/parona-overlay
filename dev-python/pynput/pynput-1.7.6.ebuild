# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1 virtualx

DESCRIPTION="Sends virtual input commands"
HOMEPAGE="
	https://pypi.org/project/pynput/
	https://github.com/moses-palmer/pynput
"
SRC_URI="https://github.com/moses-palmer/pynput/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/python-evdev[${PYTHON_USEDEP}]
	dev-python/python-xlib[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
	)
"

distutils_enable_tests unittest
distutils_enable_sphinx docs dev-python/alabaster

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	# Interactive tests
	rm tests/{keyboard,mouse}_listener_tests.py || die
	eunittest -p "*_tests.py"
}
