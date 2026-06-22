# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"
RUST_MIN_VER="1.82.0"

inherit cargo

DESCRIPTION="A utility and Rust library to convert SVG icons into Windows ICO files"
HOMEPAGE="https://github.com/Ortham/svg_to_ico"
SRC_URI="
	https://github.com/Ortham/svg_to_ico/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		https://gitlab.com/api/v4/projects/32909921/packages/generic/${PN}/${PV}/${P}-crates.tar.xz
	"
fi

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" BSD-2 BSD MIT ZLIB"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED="usr/bin/svg_to_ico"

src_install() {
	dobin $(cargo_target_dir)/svg_to_ico
	einstalldocs
}
