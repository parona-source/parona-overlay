# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit common-lisp-3

DESCRIPTION="Number parsing library"
HOMEPAGE="https://github.com/sharplispers/parse-number"
SRC_URI="
	https://github.com/sharplispers/parse-number/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

src_test() {
	local -x CL_SOURCE_REGISTRY="${S}:${CLSYSTEMROOT}"
	common-lisp-export-impl-args $(common-lisp-find-lisp-impl)
	${CL_BINARY} ${CL_EVAL} "(asdf:test-system :${PN})" || die
}

src_install() {
	common-lisp-3_src_install
	common-lisp-install-sources -t all version.sexp
	einstalldocs
}
