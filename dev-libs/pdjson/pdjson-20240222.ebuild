# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="78fe04b820dc8817f540bdd87fb22887e0ef3981"

DESCRIPTION="C JSON parser library that doesn't suck"
HOMEPAGE="https://github.com/skeeto/pdjson"
SRC_URI="
	https://github.com/skeeto/pdjson/archive/${COMMIT}.tar.gz
		-> ${PN}-${COMMIT}.tar.gz
"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="Unlicense"
SLOT="0/${PV}" # no expected abi stability
KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}"/pdjson-20240222-makefile.patch
)

#  * QA Notice: The following shared libraries lack a SONAME

src_compile() {
	emake libpdjson.so
}

src_install() {
	dolib.so libpdjson.so
	doheader pdjson.h

	insinto /usr/$(get_libdir)/pkgconfig
	newins - pdjson.pc <<-EOF
	prefix=${EPREFIX}/usr
	libdir=\${prefix}/$(get_libdir)
	includedir=\${prefix}/include

	Name: pdjson
	Version: ${PV}
	Description: Public Domain JSON parser
	URL: https://github.com/skeeto/pdjson
	Libs: -L\${libdir} -lpdjson
	Cflags: -I\${includedir}
	EOF
}
