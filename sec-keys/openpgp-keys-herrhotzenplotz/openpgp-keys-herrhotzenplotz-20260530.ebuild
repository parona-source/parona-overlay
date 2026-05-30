# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	"1A0EE08D9D3BCFB98C85A76EF373F52545A28D14:herrhotzenplotz:manual,github"
)

inherit eapi9-pipestatus sec-keys

DESCRIPTION="OpenPGP keys used by Nico Sonack (herrhotzenplotz)"
HOMEPAGE="https://herrhotzenplotz.de/"
SRC_URI+="
	https://gitlab.com/herrhotzenplotz.gpg -> ${P}-gitlab.gpg
"

KEYWORDS="~amd64"

src_test() {
	wget -qO- https://gitlab.com/herrhotzenplotz.gpg | gpg --import
	pipestatus || die

	wget -qO- https://github.com/herrhotzenplotz.gpg | gpg --import
	pipestatus || die

	sec-keys_src_test
}
