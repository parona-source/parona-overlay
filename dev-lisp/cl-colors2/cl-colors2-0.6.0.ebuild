# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit common-lisp-3

DESCRIPTION="Simple color library for Common Lisp"
HOMEPAGE="https://codeberg.org/cage/cl-colors2"
SRC_URI="
	https://codeberg.org/cage/cl-colors2/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lisp/alexandria
	dev-lisp/cl-ppcre
	dev-lisp/parse-number
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-lisp/clunit2
	)
"

src_test() {
	local -x CL_SOURCE_REGISTRY="${S}:${CLSYSTEMROOT}"
	common-lisp-export-impl-args $(common-lisp-find-lisp-impl)
	set -- ${CL_BINARY} ${CL_EVAL} "(asdf:test-system :${PN})"
	einfo "${@}"
	"${@}" || die
}
