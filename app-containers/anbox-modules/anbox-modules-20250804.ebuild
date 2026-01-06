# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1 udev

DESCRIPTION="Anbox kernel modules (ashmem and binder) fork"
HOMEPAGE="https://github.com/choff/anbox-modules"

if [[ "${PV}" == "99999999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/choff/anbox-modules"
else
	COMMIT="1434f1ebf74135a99d17e83f25d8e23908efc4cf"
	SRC_URI="https://github.com/choff/anbox-modules/archive/${COMMIT}.tar.gz -> ${PN}-choff_fork-${PV}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"

src_compile() {
	local modlist=( binder_linux=updates:binder )
	local modargs=( KERNEL_SRC="${KV_OUT_DIR}" )

	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install
	udev_dorules 99-anbox.rules
}

pkg_postinst() {
	linux-mod-r1_pkg_postinst
	udev_reload
}

pkg_postrm() {
	udev_reload
}
