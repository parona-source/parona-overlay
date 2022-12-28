# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..11} )
inherit desktop distutils-r1 systemd xdg

DESCRIPTION="The free and open-source automated time tracker."
HOMEPAGE="https://activitywatch.net/"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ActivityWatch/activitywatch"
	EGIT_SUBMODULES=( aw-{client,core,qt{,/media},server{,/aw-webui},server-rust{,/aw-webui},watched-afk,watcher-window} )
	die "dont do it"
else
	AW_CLIENT="eaec0a8dcb1fecbbc466ae5e1b57903d28c44a53"
	AW_CORE="ffef93aab19c63d4ff0ebab50b23a3f529b07d6c"
	AW_QT="8ec5db941ede0923bfe26631acf241a4a5353108"
	AW_MEDIA="cb597f7c2e2b135505fe5d6b3042960a638892cf"
	AW_SERVER="1d6d24edd1cef91fb843edc771ee3b7a5e3fc294"
	AW_SERVER_RUST="7c2b31f173194d75634079128a27ed06d83365b1"
	AW_WATCHER_AFK="ef531605cd8238e00138bbb980e5457054e05248"
	AW_WATCHER_WINDOW="47b65c3673ee0203c911a269c1858a4ffbf971c4"

	# reponame, location, commit
	AW_MODULES=(
		"aw-client aw-client ${AW_CLIENT}"
		"aw-core aw-core ${AW_CORE}"
		"aw-qt aw-qt ${AW_QT}"
		"media aw-qt/media ${AW_MEDIA}"
		"aw-server aw-server ${AW_SERVER}"
		"aw-server-rust aw-server-rust ${AW_SERVER_RUST}"
		"aw-watcher-afk aw-watcher-afk ${AW_WATCHER_AFK}"
		"aw-watcher-window aw-watcher-window ${AW_WATCHER_WINDOW}"
	)

	SRC_URI="
		https://github.com/ActivityWatch/activitywatch/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		activitywatch-${PV}-webui-prebuilt.tar.xz
	"
	KEYWORDS="~amd64"

	add_modules_to_src_uri() {
		for module in "${AW_MODULES[@]}"; do
			local repo location commit
			read -r repo location commit <<< "${module}"
			SRC_URI+=" https://github.com/ActivityWatch/${repo}/archive/${commit}.tar.gz -> activitywatch-${repo#aw-}-${commit}.tar.gz"
		done
	}
	add_modules_to_src_uri
fi

LICENSE="MPL-2.0"
SLOT="0"

#TODO
RESTRICT="server-rust"
IUSE="tray server-rust"

# ? werkzeug, python-json-logger, pymongo
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/appdirs[${PYTHON_USEDEP}]
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/deprecation[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/flask-cors[${PYTHON_USEDEP}]
		dev-python/flask-restx[${PYTHON_USEDEP}]
		dev-python/iso8601[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/peewee[${PYTHON_USEDEP}]
		dev-python/persist-queue[${PYTHON_USEDEP}]
		dev-python/pynput[${PYTHON_USEDEP}]
		dev-python/python-json-logger[${PYTHON_USEDEP}]
		dev-python/python-xlib[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/tabulate[${PYTHON_USEDEP}]
		dev-python/takethetime[${PYTHON_USEDEP}]
		dev-python/timeslot[${PYTHON_USEDEP}]
		dev-python/tomlkit[${PYTHON_USEDEP}]
		dev-python/typing-extensions
		dev-python/werkzeug[${PYTHON_USEDEP}]
	')
	tray? (
		$(python_gen_cond_dep '
			dev-python/PyQt6[${PYTHON_USEDEP}]
		')
	)
"
BDEPEND="
	test? (
		${RDEPEND}
	)
"

PYTHON_MODULE=( aw-client aw-core aw-server aw-watcher-afk aw-watcher-window )

distutils_enable_tests pytest

src_prepare() {
	if [[ "${PV}" != "9999" ]]; then
		for module in "${AW_MODULES[@]}"; do
			local repo location commit
			read -r repo location commit <<< "${module}"
			cp -rT "${WORKDIR}/${repo}-${commit}" "${S}/${location}" || die
		done
		for module in "${AW_MODULES[@]}"; do
			local repo location commit
			read -r repo location commit <<< "${module}"
			rm -rf "${WORKDIR}/${repo}-${commit}" || die
		done

		cp -rT "${WORKDIR}"/dist/ aw-server/aw_server/static/ || die
	fi

	sed -i '/pytest.ini_options/,/^$/ { /addopts/d }' "${S}"/aw-server/pyproject.toml || die

	eapply_user
}

src_configure() {
	use tray && PYTHON_MODULE+=( aw-qt )

	distutils-r1_src_configure
}

src_compile() {
	for module in "${PYTHON_MODULE[@]}"; do
		pushd "${S}/${module}" > /dev/null || die
		S="${S}/${module}" distutils-r1_src_compile
		popd > /dev/null || die
	done
}

src_install() {
	for module in "${PYTHON_MODULE[@]}"; do
		pushd "${S}/${module}" > /dev/null || die
		S="${S}/${module}" distutils-r1_src_install
		popd > /dev/null || die
	done

	systemd_dounit aw-server/misc/aw-server.service

	if use tray; then
		insinto "${XDG_CONFIG_HOME-/etc/xdg}"/autostart
		doins aw-qt/resources/aw-qt.desktop
		newicon -s 128 aw-qt/media/logo/logo-128.png ${PN}
		newicon -s 512 aw-qt/media/logo/logo.png ${PN}
	fi
}

python_test() {
	for module in "${PYTHON_MODULE[@]}"; do
		pushd ${module} > /dev/null || die
		distutils_pep517_install "${S}"
		popd > /dev/null || die
	done

	export PYTHONPATH="${S}$(python_get_sitedir):${PYTHONPATH}"
	echo ${PYTHONPATH}

	for module in "${PYTHON_MODULE[@]}"; do
		pushd ${module} > /dev/null || die
		case ${module} in
			aw-qt|aw-watcher-afk|aw-watcher-window)
				# No tests or all tests are bad
				popd > /dev/null || die
				continue
				;;
			aw-client)
				# Expects user input and a running server
				EPYTEST_IGNORE=( tests/test_{client,failqueue}.py )
				;;
			aw-server)
				EPYTEST_DESELECT=( tests/test_server.py::test_{buckets,heartbeats,get_events} )
				EPYTEST_IGNORE=( tests/test_client.py )
				;;
			*)
				;;
		esac
		epytest tests
		unset EPYTEST_DESELECT EPYTEST_IGNORE
		popd > /dev/null || die
	done
}
