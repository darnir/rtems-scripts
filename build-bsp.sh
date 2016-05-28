#!/bin/bash

# General script for building RTEMS BSPs.

## Usage: build-bsp.sh -a ARCH -b BSP [options]
##
##    -a		Machine Architecture to compile for
##    -b		BSP to compile
##
##    -s		Enable SMP Support
##    -t		Enable Tests
##
##    -c        A clean Install (remove builddir)
##    -n		Bootstrap the build first
##    -h		Display help output

__HELP=$(grep "^##" "${BASH_SOURCE[0]}" | cut -c 4-)

set -e
set -u
set -o pipefail
# set -x

SC_DIR="$(dirname "$0")"
source "$SC_DIR/include.sh"
rtems_init

LOG_DIR="$HOME/Programming/rtems/builds/logs"
mkdir -p "$LOG_DIR"

# Define empty strings for configure variables
CLEAN_INSTALL=false
ENABLE_TESTS=""
ENABLE_SMP=""
ARCH=
BSP=

export OPTERR=0
while getopts "a:b:stcn" options
do
	case $options in
		a) ARCH="$OPTARG";;
		b) BSP="$OPTARG";;
		c) CLEAN_INSTALL=true;;
		s) ENABLE_SMP="--enable-smp";;
		t) ENABLE_TESTS="--enable-tests";;
		n) pushd src/rtems; \
			./bootstrap; \
			popd;;
		*) echo "$__HELP";
			exit 0;;
	esac
done

if [[ -z "$BSP" || -z "$ARCH" ]]; then
	echo "Arch: $ARCH"
	echo "BSP : $BSP"
	echo "Both, the Arch and BSP arguments must be supplied to this script"
	exit 1
fi

# Edit these variables to change the BSP being compiled
BUILDDIR="builds/${BSP}"


if [[ -f "$LOG_DIR/${BSP}_build.log" ]]; then
	mv "$LOG_DIR/${BSP}_config.log" "$LOG_DIR/${BSP}_config.log.old" || true
	mv "$LOG_DIR/${BSP}_build.log" "$LOG_DIR/${BSP}_build.log.old"
fi

if [[ $CLEAN_INSTALL ]]; then
	rm -rf "$BUILDDIR"
fi

mkdir -p "${BUILDDIR}"
pushd "${BUILDDIR}"

if [[ $CLEAN_INSTALL ]]; then
	time ../../src/rtems/configure						\
		--target="${ARCH}-rtems${RTEMS_VER}"			\
		--enable-rtemsbsp="${BSP}"						\
		--prefix="$HOME/Programming/rtems/${RTEMS_VER}"	\
		--enable-maintainer-mode						\
		${ENABLE_TESTS}									\
		${ENABLE_SMP} 2>&1 | tee "$LOG_DIR/${BSP}_config.log"
else
	make preinstall 2>&1 | tee "$LOG_DIR/${BSP}_build_preinstall.log"
	autoreconf 2>&1 | tee "$LOG_DIR/${BSP}_config.log"
fi

make 2>&1 | tee "$LOG_DIR/${BSP}_build.log"
popd
