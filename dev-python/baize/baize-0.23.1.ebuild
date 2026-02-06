# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Powerful and exquisite WSGI/ASGI framework/toolkit."
HOMEPAGE="
	https://github.com/abersheeran/baize/
	https://pypi.org/project/baize/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		>=dev-python/httpx-0.28.1[${PYTHON_USEDEP}]
		>=dev-python/setuptools-80.9.0[${PYTHON_USEDEP}]
		>=dev-python/starlette-0.47.1[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# fragile to configuration changes
	"tests/test_asgi.py::test_request_headers"
	"tests/test_wsgi.py::test_request_headers"

	# network sandbox
	"tests/test_asgi.py::test_files"
	"tests/test_wsgi.py::test_files"
)
EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest

python_test() {
	rm -rf baize || die
	epytest
}

python_install() {
	# pdm litters gitignores all over the place
	find "${BUILD_DIR}" -name ".gitignore" -exec rm {} + || die

	distutils-r1_python_install
}
