# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_12 )

inherit distutils-r1

DESCRIPTION="A fast asyncio MySQL driver"
HOMEPAGE="
	https://pypi.org/project/asyncmy/
"
SRC_URI="
	https://github.com/long2ice/asyncmy/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		virtual/mysql
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pymysql[${PYTHON_USEDEP}]
		dev-python/mysqlclient[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	default

	# Allow setting mysql options for tests
	sed -i \
		-e 's/host="\(.*\)",/host=os.getenv("MYSQL_HOST") or "\1",/' \
		-e 's/port=\(.*\),/port=int(os.getenv("MYSQL_PORT")) or \1,/' \
		-e 's/user="\(.*\)",/user=os.getenv("MYSQL_USER") or "\1",/' \
		conftest.py || die
}

python_test() {
	rm -rf asyncmy || die

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1

	# https://github.com/long2ice/asyncmy/commit/ed22e45b8f98ebb4f010897f2d64b0c4c1f8bb3e
	# https://github.com/long2ice/asyncmy/commit/4852dcc121066431058651394dd907090f5ba849
	# https://github.com/pytest-dev/pytest-asyncio/issues/706
	epytest -o asyncio_default_fixture_loop_scope=session -p asyncio
}

src_test() {
	local -x MYSQL_HOST="127.0.0.1"
	local -x MYSQL_PORT="43307"
	local -x MYSQL_USER="root"
	local -x MYSQL_PASS="notsecret"

	local is_mariadb=0
	has_version dev-db/mariadb && is_mariadb=1

	ebegin "Creating mysql test instance"
	mkdir -p "${T}"/mysql || die
	if [[ ${is_mariadb} -ne 0 ]]; then
		local -x PATH="${BROOT}/usr/share/mariadb/scripts:${PATH}"

		mysql_install_db \
			--no-defaults \
			--auth-root-authentication-method=normal \
			--basedir="${EPREFIX}/usr" \
			--datadir="${T}"/mysql 1>"${T}"/mysqld_install.log
		ret=$?
	else
		mysqld \
			--no-defaults \
			--initialize-insecure \
			--user ${USER} \
			--basedir="${EPREFIX}/usr" \
			--datadir="${T}"/mysql 1>"${T}"/mysqld_install.log
		ret=$?
	fi
	eend ${ret} || die "mysql database couldn't be created. See ${T}/mysqld_install.log"

	ebegin "Starting mysql test instance"
	mysqld \
		--no-defaults \
		--character-set-server=utf8 \
		--bind-address=${MYSQL_HOST} \
		--port=${MYSQL_PORT} \
		--pid-file="${T}"/mysqld.pid \
		--socket="${T}"/mysqld.sock \
		--datadir="${T}"/mysql 1>"${T}"/mysqld.log 2>&1 &

	# Wait for it to start
	local fail=0 i
	for (( i = 0; i < 10; i++ )); do
		[[ -S "${T}"/mysqld.sock ]] && break
		sleep 1
	done
	[[ ! -S "${T}"/mysqld.sock ]] && fail=1
	eend ${fail} || die "mysqld failed to start. See ${T}/mysqld.log"

	ebegin "Configuring mysql test instance"
	mysql -u root --skip-password --host=${MYSQL_HOST} --port=${MYSQL_PORT} <<- EOF
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASS}';
	EOF
	eend ${?} || die "mysql couldn't be configured. See ${T}/mysqld.log"

	nonfatal distutils-r1_src_test
	ret=$?

	ebegin "Stopping mysql test instance"
	local fail=0
	pkill -F "${T}"/mysqld.pid || fail=1
	# wait for it to stop
	local i
	for (( i = 0; i < 10; i++ )); do
		[[ -S ${T}/mysqld.sock ]] || break
		sleep 1
	done

	rm -rf "${T}"/mysql || fail=1
	eend ${fail} || die "mysql failed to stop"

	[[ ${ret} -ne 0 ]] && die
}
