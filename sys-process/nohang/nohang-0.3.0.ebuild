# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
inherit python-single-r1 systemd

DESCRIPTION="A sophisticated low memory handler for Linux"
HOMEPAGE="https://github.com/hakavlad/nohang"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hakavlad/nohang.git"
else
	SRC_URI="
		https://github.com/hakavlad/nohang/archive/refs/tags/v${PV}.tar.gz
			-> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	sys-apps/util-linux
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pandoc
"

PATCHES=(
	"${FILESDIR}"/nohang-0.3.0-no-sudo.patch
)

src_prepare() {
	default

	if [[ ${PV} != 9999 ]]; then
		echo "${PV}" > version
		sed -e '/git describe/d' -i Makefile || die
	fi

	# handle manual page installation manually to avoid pre compressed man pages
	sed -e '/gzip/d' \
		-e '/rm -fv nohang.8/d' \
		-i Makefile || die
}

src_install() {
	# Use self created openrc service files
	emake DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		SYSCONFDIR="${EPREFIX}/etc" \
		DOCDIR="${EPREFIX}/usr/share/doc/${PF}" \
		SYSTEMDUNITDIR="$(systemd_get_systemunitdir)" \
		base units

	doman man/{oom-sort,psi-top,psi2log}.1 nohang.8

	sed -e "s|@@TARGET_SBINDIR@@|${EPREFIX}/usr/sbin|" \
		-e "s|@@TARGET_SYSCONFDIR@@|${EPREFIX}/etc|" \
		"${FILESDIR}/nohang.initd.in" > "${T}/nohang.initd"
	newinitd "${T}/nohang.initd" nohang
	newinitd "${T}/nohang.initd" nohang-desktop

	python_fix_shebang "${ED}"
}
