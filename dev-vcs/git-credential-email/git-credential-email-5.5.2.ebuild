# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit python-single-r1

DESCRIPTION="Git credential helpers for Microsoft Outlook, Gmail, Yahoo, AOL and Proton Mail"
HOMEPAGE="https://gce.adityagarg.is-a.dev/ https://github.com/AdityaGarg8/git-credential-email/"
SRC_URI="
	https://github.com/AdityaGarg8/git-credential-email/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="Apache-2.0 protonmail? ( GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"

IUSE="protonmail"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/keyring[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		protonmail? (
			dev-python/bcrypt[${PYTHON_USEDEP}]
			dev-python/cryptography[${PYTHON_USEDEP}]
			dev-python/pgpy[${PYTHON_USEDEP}]
			dev-python/requests-toolbelt[${PYTHON_USEDEP}]
			dev-python/typing-extensions[${PYTHON_USEDEP}]
		)
	')
"
BDEPEND="${PYTHON_DEPS}"

src_install() {
	python_doscript git-credential-aol
	python_doscript git-credential-gmail
	python_doscript git-credential-outlook
	python_doscript git-credential-yahoo
	python_doscript git-msgraph
	if use protonmail; then
		python_doscript git-protonmail
	fi
	einstalldocs
}
