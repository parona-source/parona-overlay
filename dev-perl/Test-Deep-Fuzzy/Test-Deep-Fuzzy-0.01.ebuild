# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="KARUPA"
inherit perl-module

DESCRIPTION="Fuzzy number comparison with Test::Deep"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Math-Round
	dev-perl/Test-Deep
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-perl/Module-Build-Tiny
"
