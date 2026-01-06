# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1
inherit elisp

DESCRIPTION="Tab bar integration for treemacs"
HOMEPAGE="https://github.com/Alexander-Miller/treemacs/"
SRC_URI="
	https://github.com/Alexander-Miller/treemacs/archive/${PV}.tar.gz
		-> treemacs-${PV}.gh.tar.gz
"
S="${WORKDIR}/treemacs-${PV}/src/extra"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-emacs/dash
	app-emacs/treemacs
"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile "${PN}.el"
}

src_install() {
	elisp-install "${PN}" "${PN}.el"{,c}
	elisp-make-site-file "${SITEFILE}"
}
