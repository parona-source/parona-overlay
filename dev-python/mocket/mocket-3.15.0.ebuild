# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Socket Mock Framework"
HOMEPAGE="
	https://github.com/mindflayer/python-mocket/
	https://pypi.org/project/mocket/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/puremagic[${PYTHON_USEDEP}]
	>=dev-python/decorator-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.25.3[${PYTHON_USEDEP}]
	dev-python/h11[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.6.0[${PYTHON_USEDEP}]
"
# avoid gevent
# wait-for-it not needed
# avoid redis so that you dont need to run it
BDEPEND="
	test? (
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/asgiref[${PYTHON_USEDEP}]
		dev-python/fastapi[${PYTHON_USEDEP}]
		dev-python/httpx[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/sure[${PYTHON_USEDEP}]
		dev-python/trio[${PYTHON_USEDEP}]
		dev-python/xxhash[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# network sandbox
	"tests/test_asyncio.py::test_asyncio_record_replay"
	"tests/test_asyncio.py::test_aiohttp"
)

EPYTEST_IGNORE=(
	# avoid gevent
	"tests/test_http_gevent.py"
	# Avoid running redis for tests for now
	"tests/test_redis.py"
	# typing broken? httpx <-> fastapi <-> anyio?
	"tests/test_httpx.py"
	"tests/test_http_httpx.py"
)

python_test() {
	local -x SKIP_TRUE_HTTP=true
	epytest -o addopts=
}
