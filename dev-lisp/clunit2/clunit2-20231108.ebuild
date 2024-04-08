# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Unit Testing Framework, fork of clunit."
HOMEPAGE="https://codeberg.org/cage/clunit2"
COMMIT="b24c56851ee6ee6c4a9dc3725a634c06b604f207"
SRC_URI="
	https://codeberg.org/cage/clunit2/archive/${COMMIT}.tar.gz
		-> ${PN}-${COMMIT}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
