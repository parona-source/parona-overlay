# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit common-lisp-3

DESCRIPTION="Enables ANSI colors for printing."
HOMEPAGE="https://github.com/pnathan/cl-ansi-text"
SRC_URI="
	https://github.com/pnathan/cl-ansi-text/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="LLGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lisp/alexandria
	dev-lisp/cl-colors2
"
BDEPEND="
	test? (
		${RDEPEND}
	)
"

src_test() {
	local -x CL_SOURCE_REGISTRY="${S}:${CLSYSTEMROOT}"
	common-lisp-export-impl-args $(common-lisp-find-lisp-impl)
	set -- ${CL_BINARY} ${CL_EVAL} "(asdf:test-system :${PN})"
	einfo "${@}"
	"${@}" || die
}
