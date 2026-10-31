# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

MY_P="opentelemetry-python-${PV}"

DESCRIPTION="OpenTelemetry Exporters HTTP transport"
HOMEPAGE="
	https://opentelemetry.io/
	https://pypi.org/project/opentelemetry-exporter-http-transport/
	https://github.com/open-telemetry/opentelemetry-python/
"

SRC_URI="
	https://github.com/open-telemetry/opentelemetry-python/archive/refs/tags/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}/exporter/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	~dev-python/opentelemetry-api-${PV}[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mocket[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/urllib3[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
