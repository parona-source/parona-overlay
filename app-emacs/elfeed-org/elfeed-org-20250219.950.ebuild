# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

COMMIT="1197cf29f6604e572ec604874a8f50b58081176a"

DESCRIPTION="Configure elfeed with one or more org-mode files"
HOMEPAGE="
	https://melpa.org/#/elfeed-org/
	https://github.com/remyhonig/elfeed-org/
"
SRC_URI="
	https://github.com/remyhonig/elfeed-org/archive/${COMMIT}.tar.gz
		-> ${PN}-${COMMIT}.gh.tar.gz
"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-editors/emacs-28.1:*
	>=app-emacs/elfeed-1.1.1

"
BDEPEND="
	test? (
		${RDEPEND}
		app-emacs/xtest
	)
"

SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert-runner "${S}/test"
