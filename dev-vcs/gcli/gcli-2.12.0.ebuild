# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit verify-sig

DESCRIPTION="Portable CLI tool for interacting with Git(Hub|Lab|Tea) from the command line"
HOMEPAGE="https://herrhotzenplotz.de/gcli/"
SRC_URI="
	https://herrhotzenplotz.de/gcli/releases/${P}/${P}.tar.xz
	verify-sig? (
		https://herrhotzenplotz.de/gcli/releases/${P}/SHA256SUMS -> ${P}-SHA256SUMS
		https://herrhotzenplotz.de/gcli/releases/${P}/SHA256SUMS.asc -> ${P}-SHA256SUMS.asc
	)

"

LICENSE="BSD-2 Unlicense"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+libedit lowdown test"
RESTRICT="!test? ( test )"

# pdjson isnt system installable without patches

RDEPEND="
	dev-libs/openssl:=
	net-misc/curl[openssl]
	x11-misc/xdg-utils
	libedit? (
		dev-libs/libedit
	)
	!libedit? (
		sys-libs/readline:=
	)
	lowdown? (
		app-text/lowdown:=
	)
"
DEPEND="
	${RDEPEND}
	test? (
		dev-libs/atf
		dev-lang/perl
	)
"
BDEPEND="
	virtual/pkgconfig
	verify-sig? (
		sec-keys/openpgp-keys-herrhotzenplotz
	)
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/herrhotzenplotz.asc

src_unpack() {
	if use verify-sig; then
		pushd "${DISTDIR}" >/dev/null || die
		verify-sig_verify_detached ${P}-SHA256SUMS{,.asc}
		verify-sig_verify_unsigned_checksums ${P}-SHA256SUMS sha256 ${P}.tar.xz
		popd >/dev/null || die
	fi
	default
}

src_configure() {
	# use ccache via portage
	local -x CCACHE=" " # whitespace required...

	# avoid compressed manpages...
	local -x GZIP="true"

	local myconf=(
		--prefix="${EPREFIX}/usr"
		$(usev !libedit --disable-libedit)
		$(usev libedit --disable-libreadline)
		$(usev !lowdown --disable-liblowdown)
		$(usev !test --disable-tests)
	)

	./configure ${myconf[@]} || die
}

src_install() {
	# avoid precompressed manpages
	emake DESTDIR="${D}" MANPAGES= install
	emake manpages
	doman docs/*.[0-9]

	einstalldocs
}
