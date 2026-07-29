# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Vulkan layer for hardware agnostic input latency reduction"
HOMEPAGE="https://github.com/Korthos-Software/low_latency_layer"
SRC_URI="
	https://github.com/Korthos-Software/low_latency_layer/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-util/vulkan-utility-libraries
"
DEPEND="
	${RDEPEND}
	dev-util/vulkan-headers
"
