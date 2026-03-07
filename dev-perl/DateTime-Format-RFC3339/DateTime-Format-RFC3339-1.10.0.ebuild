# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="IKEGAMI"
DIST_VERSION="v${PV}"
inherit perl-module

DESCRIPTION="Parse and format RFC3339 datetime strings for DateTime"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/DateTime
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.74
	test? (
		dev-perl/Test-Pod
	)
"
