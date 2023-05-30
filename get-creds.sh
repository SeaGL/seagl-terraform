#!/bin/sh

set -eu

function die() {
	echo fatal: $@ 1>&2
	exit 1
}

if pushd $(git rev-parse  --show-toplevel); then
	if ! test -f .os_username; then
		read -rp 'OSUOSL OpenStack username: ' OS_USERNAME_INPUT
		printf $OS_USERNAME_INPUT > .os_username
	fi
	export OS_USERNAME=$(cat .os_username)
	popd
else
	die 'must be run from git repo'
fi

#printf "OSUOSL OpenStack password: "
read -srp 'OSUOSL OpenStack password: ' OS_PASSWORD_INPUT
export OS_PASSWORD=$OS_PASSWORD_INPUT
echo

bash
