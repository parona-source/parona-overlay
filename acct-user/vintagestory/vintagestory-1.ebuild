# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Dedicated user for vintagestory"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( vintagestory )

acct-user_add_deps
