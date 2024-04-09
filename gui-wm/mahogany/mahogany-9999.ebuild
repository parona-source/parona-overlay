# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CLIMPLEMENTATIONS="sbcl"

inherit common-lisp-3 meson

DESCRIPTION="A stumpwm like Wayland compositor"
HOMEPAGE=""

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/stumpwm/mahogany/"
	EGIT_SUBMODULES=( -wlroots )
else
	die "Not implemented"
	SRC_URI=""
	KEYWORDS=""
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND="
	gui-libs/wlroots:0/17
	dev-lisp/alexandria
	dev-lisp/cl-ansi-text
	dev-lisp/terminfo
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-lisp/cl-bindgen
"

EMESON_SOURCE="${S}/heart"

src_prepare() {
	default
	sed -i -e "s|build|${S}/heart|" lisp/bindings/hrt-bindings.yml || die
}

src_compile() {
	meson_src_compile
	cl-bindgen b lisp/bindings/hrt-bindings.yml || die
	set -- sbcl --non-interactive --load build-mahogany.lisp
	einfo ${@}
	"${@}" || die
}

src_test() {
	meson_src_test
	emake test
	#$(common-lisp-find-lisp-impl) $(common-lisp-export-impl-args $(common-lisp-find-lisp-impl )) run-tests.lisp || die
}

src_install() {
	meson_src_install
	common-lisp-3_src_install
	einstalldocs
}
