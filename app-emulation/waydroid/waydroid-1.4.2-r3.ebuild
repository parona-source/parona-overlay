# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit linux-info optfeature python-single-r1 xdg

DESCRIPTION="Container-based approach to boot a full Android system"
HOMEPAGE="https://waydro.id/"
SRC_URI="https://github.com/waydroid/waydroid/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="apparmor nftables split-usr"
RESTRICT="test" # no tests

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/gbinder[${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP}]
	')
	app-admin/sudo
	app-emulation/anbox-modules
	app-containers/lxc[apparmor?,tools]
"
BDEPEND="${PYTHON_DEPS}"

CONFIG_CHECK="
	PSI
	~!PSI_DEFAULT_DISABLED
"

# https://github.com/waydroid/waydroid/issues/136
ERROR_PSI_DEFAULT_DISABLED="CONFIG_PSI_DEFAULT_DISABLED: waydroid container will fail if PSI isn't enabled by default or enabled through boot parameters with psi=1"

# https://github.com/waydroid/waydroid/issues/631

pkg_setup() {
	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	eapply_user
	python_fix_shebang waydroid.py tools

	# workaround for split-usr
	# https://github.com/waydroid/waydroid/issues/1005
	use split-usr && sed -i -e "s|modprobe|${EPREFIX}/sbin/modprobe|" tools/helpers/drivers.py || die
}

src_compile() {
	:
}

src_install() {
	emake \
		DESTDIR="${D}" \
		USE_SYSTEMD=1 USE_DBUS_ACTIVATION=1 USE_NFTABLES=$(usex nftables 1 0) \
		install $(usev apparmor install_apparmor)

	python_optimize "${D}/usr/lib/waydroid"
}

pkg_postinst() {
	xdg_pkg_postinst

	einfo "# emerge --config waydroid"
	einfo "$ waydroid session start"

	optfeature "clipboard support" dev-python/pyclip
}

pkg_config() {
	local rom_type system_type

	einfo "Rom type?"
	einfo "lineage, bliss or OTA channel URL"
	read -p "(lineage)> " rom_type
	rom_type="${rom_type:-lineage}"

	einfo "System type?"
	einfo "VANILLA, FOSS or GAPPS"
	read -p "(VANILLA)> " system_type
	system_type="${system_type:-VANILLA}"

	set -- "${EROOT}"/usr/bin/waydroid init -f -r "${rom_type}" -s "${system_type}"
	einfo "${@}"
	"${@}" || die "Waydroid initialisation failed"

	# https://github.com/waydroid/waydroid/issues/652
	use !apparmor && sed -i -e '/lxc.apparmor/d' "${EPREFIX}"/var/lib/waydroid/lxc/waydroid/config || die
}
