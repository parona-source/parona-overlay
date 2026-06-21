# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

#TODO: ability to give flags to FPC by the user?

# @ECLASS: lazarus.eclass
# @MAINTAINER:
# Alfred Wingate <parona@protonmail.com>
# @AUTHOR:
# Alfred Wingate <parona@protonmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: common ebuild function for lazarus-based ebuilds

case ${EAPI} in
	8|9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_LAZARUS_ECLASS} ]]; then
_LAZARUS_ECLASS=1

inherit multiprocessing
[[ ${EAPI} == 8 ]] && inherit edo

# @ECLASS_VARIABLE: LAZARUS_WIDGET
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set the project widget. Adds the option --widgetset and required dependencies if set.
# Supported values: gtk2 gtk3 qt6

if [[ -n ${LAZARUS_WIDGET} ]]; then
	case ${LAZARUS_WIDGET} in
		gtk2)
			RDEPEND="x11-libs/gtk+:2="
			DEPEND="x11-libs/gtk+:2="
			BDEPEND="dev-lang/lazarus[gtk2(-)]"
			;;
		gtk3)
			RDEPEND="x11-libs/gtk+:3="
			DEPEND="x11-libs/gtk+:3="
			BDEPEND="dev-lang/lazarus[gtk(-)]"
			;;
		qt6)
			RDEPEND="dev-libs/libqt6pas:="
			DEPEND="dev-libs/libqt6pas:="
			BDEPEND="dev-lang/lazarus[qt6(-)]"
			;;
		*)
			die "Unknown LAZARUS_WIDGET value: ${LAZARUS_WIDGET}"
			;;
	esac
fi

# @ECLASS_VARIABLE: MYLAZARUSARGS
# @USER_VARIABLE
# @DESCRIPTION:
# User-controlled environment variable containing arguments to be passed to lazbuild.

# @ECLASS_VARIABLE: LAZARUSARGS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Arguments to pass to Lazarus. Set by lazarus_src_configure.

# @FUNCTION: lazarus_src_configure
# @DESCRIPTION:
# Configure options for fpc and lazarus.
lazarus_src_configure() {
	# https://wiki.freepascal.org/Configuration_file
	export PPC_CONFIG_PATH="${T}/fpc/"
	mkdir -p "${PPC_CONFIG_PATH}" || die
	cat > "${PPC_CONFIG_PATH}"/fpc.cfg <<-EOF
	# Get system wide configuration for the correct searchpaths.
	#INCLUDE ${EPREFIX}/etc/fpc.cfg

	# Then override options from that system wide configuration

	# Disable stripping. The package manager handles stripping and keeping the debug symbols.
	-Xs-

	# Enable build-id's
	-k --build-id
	EOF

	local _lazarusargs=(
		--max-process-count=$(get_makeopts_jobs)
		--verbose
		--lazarusdir=/usr/share/lazarus/
		--primary-config-path="${T}"/lazconfig
		${LAZARUS_WIDGET:+--widgetset=${LAZARUS_WIDGET}}
		${MYLAZARUSARGS}
	)
	export LAZARUSARGS="${_lazarusargs[@]}"
	readonly LAZARUSARGS
}

# @FUNCTION: elazbuild
# @USAGE: [<args>...]
# @DESCRIPTION:
# Call lazbuild with default arguments in addition to supplied arguments.
elazbuild() {
	edo lazbuild ${LAZARUSARGS} ${@}
}

fi

EXPORT_FUNCTIONS src_configure
