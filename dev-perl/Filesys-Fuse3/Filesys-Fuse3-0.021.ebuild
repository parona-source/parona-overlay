# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="DDUMONT"
DIST_TEST="do" # order important
inherit perl-module

DESCRIPTION="Create filesystems in Perl using Fuse3"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

# Uses /dev/fuse
RESTRICT="test"
PROPERTIES="test_privileged"

RDEPEND="
	dev-perl/Lchown
	dev-perl/Filesys-Statvfs
	dev-perl/Unix-Mknod
	sys-fs/fuse:3
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	mkdir -p ${T}/test || die
	sed -e "/^my \$tmp =/ s|= .*|= '${T}/test';|" -i test/helper.pm || die

	# use fuse3 for tests
	sed -e 's/fusermount /fusermount3 /' -i test/s/umount.t || die
}

src_test() {
	addwrite /dev/fuse
	perl-module_src_test
}
