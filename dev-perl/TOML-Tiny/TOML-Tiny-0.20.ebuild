# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="OALDERS"
inherit perl-module

DESCRIPTION="Minimal, pure perl TOML parser and serializer"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=virtual/perl-Math-BigInt-1.999718
"
DEPEND="
	${RDEPEND}
	test? (
		dev-perl/DateTime-Format-ISO8601
		dev-perl/DateTime-Format-RFC3339
		dev-perl/Test-Pod
		dev-perl/TOML-Parser
	)
"
