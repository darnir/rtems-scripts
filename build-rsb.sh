#!/bin/bash

# Author: Darshit Shah <darnir@gmail.com>

# Build the RTEMS Source Builder
# Check README for expected directory layout
# Must be edited to change any configuration settings

set -e
set -u
set -o pipefail

SC_DIR="$(dirname "$0")"
source "$SC_DIR/include.sh"
rtems_init

if [[ $# -eq 2 ]]; then
	__RTEMS_VER="$1"
	__RTEMS_BSET="$2"
else
	__RTEMS_VER="$RTEMS_VER"
	__RTEMS_BSET="$RTEMS_VER/rtems-arm"
fi

pushd src/rtems-source-builder
source-builder/sb-check
pushd rtems
# ../source-builder/sb-set-builder --list-bsets
command time ../source-builder/sb-set-builder \
	--log="l-${__RTEMS_BSET}.log" \
	--prefix="$HOME/Programming/rtems/${__RTEMS_VER}" \
	"${__RTEMS_BSET}"
popd
popd
