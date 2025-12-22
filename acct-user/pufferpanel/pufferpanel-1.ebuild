# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Dedicated user for pufferpanel"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( pufferpanel docker )

ACCT_USER_HOME=/var/lib/pufferpanel

acct-user_add_deps
