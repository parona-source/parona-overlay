# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Data type for representing time slots with a start and end."
HOMEPAGE="
	https://pypi.org/project/timeslot/
	https://github.com/ErikBjare/timeslot
"

# No tags and pypi tarball doesnt include tests so going with current commit as of 2022-12-27
COMMIT="af35445e96cbb2f3fb671a75aac6aa93e4e7e7a6"
SRC_URI="https://github.com/ErikBjare/timeslot/archive/${COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest

src_prepare() {
	eapply_user

	sed -i '/pytest\.ini_options/,/^$/ { /addopts/d }' pyproject.toml || die
}
