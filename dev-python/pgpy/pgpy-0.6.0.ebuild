# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Pretty Good Privacy for Python (temporary fork for py3.13 compatability)"
HOMEPAGE="
	https://github.com/memory/PGPy/
	https://pypi.org/project/pgpy13/
"
# no tests in sdist
COMMIT="aa4ef19a0d621f0ea985f103617f18712a6009ae"
SRC_URI="
	https://github.com/SecurityInnovation/PGPy/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/PGPy-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

# https://github.com/SecurityInnovation/PGPy/issues/462
RDEPEND="
	>=dev-python/cryptography-38.0.0[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/gpgmepy[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-order )
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/pgpy-6.0.0-python3.13.patch
	"${FILESDIR}"/pgpy-6.0.0-reserved-flags.patch
	"${FILESDIR}"/pgpy-6.0.0-cryptography-compat.patch
	"${FILESDIR}"/pgpy-6.0.0-test-key-size.patch
	"${FILESDIR}"/pgpy-6.0.0-test-fix-gpg-verify.patch
)
