# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit verify-sig

DESCRIPTION="The Linux Crypto Undertaker"
HOMEPAGE="
	https://dyne.org/tomb/
	https://github.com/dyne/tomb/
"
SRC_URI="
	https://files.dyne.org/api/download?path=/tomb/releases/Tomb-2.13.tar.gz
	verify-sig? (
		https://files.dyne.org/api/download?path=/tomb/releases/Tomb-2.13.tar.gz.asc
		https://files.dyne.org/api/download?path=/tomb/releases/Tomb-2.13.tar.gz.sha
	)
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-crypt/gnupg
	app-crypt/pinentry
	sys-apps/file
	sys-fs/cryptsetup
"
BDEPEND=""

src_unpack() {
	pushd "${DISTDIR}" >/dev/null || die
	verify-sig_verify_unsigned_checksums Tomb-2.13.tar.gz.sha sha256 Tomb-2.13.tar.gz
	verify-sig_verify_detached Tomb-2.13.tar.gz{,.sig}
	popd >/dev/null || die
	default
}
