# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=8.0
inherit dotnet-pkg-base

DESCRIPTION="Uncompromising wilderness survival sandbox game (requires paid account) (server)"
HOMEPAGE="https://www.vintagestory.at/"

if [[ ${PV} =~ _rc ]]; then
	MY_PV="${PV/_rc/-rc.}"
	SRC_URI="
		amd64? ( https://cdn.vintagestory.at/gamefiles/unstable/vs_server_linux-x64_${MY_PV}.tar.gz )
	"
else
	SRC_URI="
		amd64? ( https://cdn.vintagestory.at/gamefiles/stable/vs_server_linux-x64_${PV}.tar.gz )
	"
	KEYWORDS="-* ~amd64"
fi
S="${WORKDIR}/${PN}"

LICENSE="all-rights-reserved"
SLOT="0"

REQUIRED_USE="elibc_glibc"
RESTRICT="bindist mirror strip"

# https://wiki.vintagestory.at/index.php?title=Installing_the_game_on_Linux
RDEPEND="
	${DOTNET_PKG_RDEPS}
	acct-user/vintagestory
	acct-group/vintagestory
"
BDEPEND="${DOTNET_PKG_BDEPS}"

QA_PREBUILT="*"
QA_PRESTRIPPED="*"

DESTDIR="/opt/${PN}-server"

src_prepare() {
	default

	rm server.sh || die
}

src_install() {
	insinto ${DESTDIR}
	doins -r .

	fperms +x ${DESTDIR}/VintagestoryServer

	dotnet-pkg-base_launcherinto "${DESTDIR}"
	dotnet-pkg-base_dolauncher "${DESTDIR}/VintagestoryServer" VintagestoryServerWrapper

	insinto /usr/lib/sysctl.d
	newins - 60-vintagestory-server.conf <<-EOF
	# https://wiki.vintagestory.at/Troubleshooting_Guide#Error:_Garbage_collector_could_not_allocate_16384u_bytes_of_memory_for_major_heap_section.
	vm.max_map_count = 262144
	EOF
}
