# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Vulkan layer for color grading for Linux games"
HOMEPAGE="https://github.com/reakjra/vkSumi"
SRC_URI="
	https://github.com/reakjra/vkSumi/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/vulkan-loader
"
RDEPEND="${RDEPEND}
	dev-util/vulkan-headers
	x11-libs/libX11
"
BDEPEND="
	dev-util/glslang
"
