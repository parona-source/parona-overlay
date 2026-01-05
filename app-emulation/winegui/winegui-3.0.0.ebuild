# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake gnome2-utils xdg

DESCRIPTION="A user-friendly WINE manager"
HOMEPAGE="https://gitlab.melroy.org/melroy/winegui"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.melroy.org/melroy/winegui.git"
else
	SRC_URI="
		https://winegui.melroy.org/downloads/WineGUI-Source-v${PV}.tar.gz
	"
fi

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="doc"

DEPEND="
	dev-cpp/gtkmm:4.0
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen[dot]
	)
"

PATCHES=(
	"${FILESDIR}"/winegui-3.0.0-gcc16.patch
)

src_unpack() {
	mkdir "${S}" || die
	cd "${S}" || die
	unpack WineGUI-Source-v${PV}.tar.gz
}

src_prepare() {
	cmake_src_prepare

	# no automagic ccache
	sed -e '/find_program(CCACHE_PROGRAM ccache)/d' -i CMakeLists.txt || die

	# -Werror is excessive
	sed -e '/set(CMAKE_CXX_FLAGS/ s/-Werror//' -i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DDOXYGEN=$(usex doc)
		-DCHECK_FOR_UPDATE=OFF
		-DGSETTINGS_LOCALCOMPILE=OFF
	)
	cmake_src_configure
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_schemas_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
