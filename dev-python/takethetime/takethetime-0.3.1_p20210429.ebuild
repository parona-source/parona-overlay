# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1

MY_PN="TakeTheTime"

DESCRIPTION="Take The Time, a time-taking library for Python"
HOMEPAGE="
	https://pypi.org/project/takethetime/
	https://github.com/ErikBjare/TakeTheTime
"

# No tagged releases nor tests in pypi tarball
COMMIT="b0042ac5b1cc9d3b70ef59167b094469ceb660dd"
SRC_URI="https://github.com/ErikBjare/${MY_PN}/archive/${COMMIT}.tar.gz -> ${MY_PN}-${PV}.gh.tar.gz"
S="${WORKDIR}/${MY_PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests unittest

python_test() {
	eunittest tests
}
