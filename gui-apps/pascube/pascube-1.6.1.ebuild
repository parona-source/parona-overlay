# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LAZARUS_WIDGET=qt6
inherit desktop edo flag-o-matic lazarus toolchain-funcs xdg

DESCRIPTION="A simple opengl spinning cube in pascal"
HOMEPAGE="https://github.com/benjamimgois/pascube/"
SRC_URI="
	https://github.com/benjamimgois/pascube/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-2 ZLIB"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/libsdl2
	media-libs/mesa
	virtual/zlib:=
	x11-libs/libX11
"
DEPEND="${RDEPEND}"

QA_FLAGS_IGNORED=".*"

src_configure() {
	# weird build that cannot handle lto
	filter-lto
}

src_compile() {
	edo $(tc-getCC) -c ${CFLAGS} -fverbose-asm -fno-builtin \
		"pasvulkan/src/lzma_c/LzmaDec.c" -o "pasvulkan/src/lzma_c/lzmadec_linux_x86_64.o"
	elazbuild pascube.lpi
}

src_install() {
	exeinto /usr/lib/pascube/bin/
	doexe bin/pascube

	insinto /usr/lib/pascube/
	doins -r assets

	newbin - pascube <<-EOF
	#!/bin/sh
	export QT_QPA_PLATFORM=xcb
	exec /usr/lib/pascube/bin/pascube "$@"
	EOF

	domenu data/pascube.desktop
	for size in 128 256 512; do
		doicon -s ${size} data/icons/${size}x${size}/pascube.png
	done

	insinto /usr/share/pascube/
	doins data/skybox.png data/skybox1.png

	einstalldocs
}
