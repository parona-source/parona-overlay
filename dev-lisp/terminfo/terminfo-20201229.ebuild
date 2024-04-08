# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit common-lisp-3

DESCRIPTION="Terminfo database front-end."
HOMEPAGE="https://github.com/npatrick04/terminfo"
COMMIT="b8b2e3ed786bfcf9f1aa4a264cee2e93135080f5"
SRC_URI="
	https://github.com/npatrick04/terminfo/archive/${COMMIT}.tar.gz
		-> ${PN}-${COMMIT}.tar.gz
"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
