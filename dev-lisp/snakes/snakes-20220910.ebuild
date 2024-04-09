# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit common-lisp-3

DESCRIPTION="Python style generators for Common Lisp."
HOMEPAGE="https://github.com/BnMcGn/snakes"
COMMIT="b1e35328ddd558819eb67b7927d7548f93d14210"
SRC_URI="
	https://github.com/BnMcGn/snakes/archive/${COMMIT}.tar.gz
		-> ${PN}-${COMMIT}.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lisp/cl-cont
	dev-lisp/closer-mop
	dev-lisp/fiveam
	dev-lisp/iterate
	dev-lisp/cl-utilities
	dev-lisp/alexandria
"
BDEPEND="
	test? (
		${RDEPEND}
	)
"
