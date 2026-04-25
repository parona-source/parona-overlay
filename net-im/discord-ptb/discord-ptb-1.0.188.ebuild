# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit chromium-2 desktop linux-info optfeature unpacker xdg

DESCRIPTION="All-in-one voice and text chat for gamers"
HOMEPAGE="https://discordapp.com"
SRC_URI="https://dl-ptb.discordapp.net/apps/linux/${PV}/${P}.deb"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"

RESTRICT="bindist mirror strip test"

# updater_bootstrap
RDEPEND="
	sys-libs/glibc
	|| (
		sys-devel/gcc
		llvm-runtimes/libgcc
	)
"

# The installed binary
RDEPEND+="
	>=app-accessibility/at-spi2-core-2.46.0:2
	app-crypt/libsecret
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/mesa[gbm(+)]
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
"

CONFIG_CHECK="~USER_NS"
QA_PREBUILT="*"

DESTDIR="/opt/${PN}"

src_prepare() {
	default
	# remove post-install script
	rm usr/share/${PN}/postinst.sh || die "the removal of the unneeded post-install script failed"
}

src_configure() {
	default
	chromium_suid_sandbox_check_kernel_config
}

src_install() {
	dobin usr/bin/${PN}
	newicon -s 256 usr/share/${PN}/discord.png ${PN}.png
	domenu usr/share/${PN}/${PN}.desktop

	exeinto "${DESTDIR}"
	doexe usr/share/${PN}/updater_bootstrap

	insinto /etc/apparmor.d/
	doins etc/apparmor.d/${PN}
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature_header "Install the following packages for additional support:"
	optfeature "sound support" \
		media-sound/pulseaudio-daemon media-sound/apulse[sdk] media-video/pipewire
	optfeature "emoji support" media-fonts/noto-emoji
}
