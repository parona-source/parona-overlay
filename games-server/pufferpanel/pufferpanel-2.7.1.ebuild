# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="A game server management panel"
HOMEPAGE="https://pufferpanel.com"
SRC_URI="
	https://github.com/pufferpanel/pufferpanel/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	https://gitlab.com/api/v4/projects/32909921/packages/generic/${PN}/${PV}/${P}-deps.tar.xz
	https://gitlab.com/api/v4/projects/32909921/packages/generic/${PN}/${PV}/${P}-dist.tar.xz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-group/pufferpanel
	acct-user/pufferpanel
	app-containers/docker
"

src_compile() {
	ego build \
		-o pufferpanel \
		-ldflags "-X 'github.com/pufferpanel/pufferpanel/v2.Hash=(gentoo)' -X 'github.com/pufferpanel/pufferpanel/v2.Version=${PV}'" \
		-v github.com/pufferpanel/pufferpanel/v2/cmd
}

src_install() {
	# Follow instructions from github workflow

	dobin pufferpanel

	keepdir /var/lib/pufferpanel
	keepdir /var/lib/pufferpanel/binaries
	keepdir /var/log/pufferpanel

	insinto /etc/pufferpanel
	newins config.linux.json config.json
	insinto /var/www/pufferpanel
	doins -r "${WORKDIR}"/dist/*
	insinto /etc/pufferpanel
	doins -r assets/email
	systemd_dounit systemd/servicefiles/pufferpanel.service

	fowners -R pufferpanel:pufferpanel /var/log/pufferpanel /etc/pufferpanel /var/www/pufferpanel /var/lib/pufferpanel

	einstalldocs
}
