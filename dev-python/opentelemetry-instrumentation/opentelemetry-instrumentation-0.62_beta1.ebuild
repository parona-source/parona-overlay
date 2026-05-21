# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{13..14} )

inherit distutils-r1 pypi

DESCRIPTION="Instrumentation Tools & Auto Instrumentation for OpenTelemetry Python"
HOMEPAGE="
	https://github.com/open-telemetry/opentelemetry-python-contrib
	https://pypi.org/project/opentelemetry-instrumentation/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

OTIO_VER="1.41.1"

RDEPEND="
	~dev-python/opentelemetry-api-${OTIO_VER}[${PYTHON_USEDEP}]
	~dev-python/opentelemetry-semantic-conventions-${OTIO_VER}[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		~dev-python/opentelemetry-test-utils-${OTIO_VER}[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
