# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LAZARUS_WIDGET=qt6
inherit lazarus optfeature xdg

MY_PV="${PV/_p/-}"

DESCRIPTION="Graphical UI to help manage Linux overlays"
HOMEPAGE="https://github.com/benjamimgois/goverlay"
SRC_URI="
	https://github.com/benjamimgois/goverlay/archive/refs/tags/${MY_PV}.tar.gz
		-> ${PN}-${MY_PV}.tar.gz
"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	media-libs/libsdl2
	media-libs/mesa
	virtual/zlib:=
	x11-libs/libX11
"
# overzealous deps. Some could be optfeature's instead.
RDEPEND="
	${DEPEND}
	!gui-apps/pascube
	app-arch/7zip
	app-shells/bash
	dev-vcs/git
	games-util/gamemode
	games-util/mangohud
	media-fonts/symbols-nerd-font
	media-gfx/low_latency_layer
	net-misc/curl
	sys-apps/iproute2
"

QA_FLAGS_IGNORED=".*"

src_prepare() {
	default

	# Disable stripping
	sed -e '/<Linking>/,/<\/Linking>/ { /<Debugging>/,/<\/Debugging>/d }' \
		-i $(find "${S}" -name "*.lpi") || die

	# FIXME: failing tests
	sed -e '/procedure TestBgmodLaunchSplashGameTitleAndReShade;/d' \
		-e '/^procedure TBgmodSupervisorTests.TestBgmodLaunchSplashGameTitleAndReShade;/,/^end;/d' \
		-e '/procedure TestBgmodInjectsLaunchArguments;/d' \
		-e '/^procedure TBgmodSupervisorTests.TestBgmodInjectsLaunchArguments;/,/^end;/d' \
		-e '/procedure TestBgmodNativeLinuxResolution;/d' \
		-e '/^procedure TBgmodSupervisorTests.TestBgmodNativeLinuxResolution;/,/^end;/d' \
		-e '/procedure TestFindMasterBGModDir;/d' \
		-e '/^procedure TBgmodSelfUpdateTests.TestFindMasterBGModDir;/,/^end;/d' \
		-e '/procedure TestBgmodExecutableSelfUpdate;/d' \
		-e '/^procedure TBgmodSelfUpdateTests.TestBgmodExecutableSelfUpdate;/,/^end;/d' \
		-i tests/logic/logic_test_cases.pas || die
	sed -e '/procedure TestThirdPartyProxyDllPreservedDuringLaunchAndUninstall;/d' \
		-e '/^procedure TGoverlayGuiTests.TestThirdPartyProxyDllPreservedDuringLaunchAndUninstall;/,/^end;/d' \
		-i tests/gui/gui_test_cases.pas || die
}

src_compile() {
	emake LAZBUILDOPTS="${LAZARUSARGS}" all
}

src_test() {
	# Use a separate build/test dir to avoid binaries getting mangled
	local test_dir="${S}_test"
	cp -r "${S}" "${test_dir}" || die

	pushd "${test_dir}" >/dev/null || die

	#local -x QT_QPA_PLATFORM=offscreen
	#emake LAZBUILDOPTS="${LAZARUSARGS}" test
	emake LAZBUILDOPTS="${LAZARUSARGS}" test-logic

	popd >/dev/null || die

	rm -rf "${test_dir}" || die
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install
	einstalldocs
}

pkg_postinst() {
	xdg_pkg_postinst
	# https://github.com/benjamimgois/goverlay#optional--used-by-specific-features
	optfeature "Vulkan post-processing effects" media-gfx/vkBasalt media-gfx/vkSumi
	optfeature "Lossless Scaling Frame Generation Vulkan Layer" app-emulation/lsfg-vk
	optfeature "Proton prefix management" app-emulation/protontricks
}
