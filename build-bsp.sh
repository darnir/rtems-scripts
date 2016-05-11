#!/bin/bash

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
ENABLE_TESTS=""
ENABLE_SMP=""

while getopts "a:b:stn" options
do
	case $options in
		a) ARCH="$OPTARG";;
		b) BSP="$OPTARG";;
		s) ENABLE_SMP="--enable-smp";;
		t) ENABLE_TESTS="--enable-tests";;
		n) pushd src/rtems; \
			./bootstrap; \
			popd;;
		*) false;;
	esac
done

if [[ -z "$BSP" || -z "$ARCH" ]]; then
	echo "Arch: $ARCH"
	echo "BSP : $BSP"
	echo "Both, the Arch and BSP arguments must be supplied to this script"
fi

# Edit these variables to change the BSP being compiled
BUILDDIR="builds/${BSP}"


if [[ -f "$LOG_DIR/${BSP}_build.log" ]]; then
	mv "$LOG_DIR/${BSP}_config.log" "$LOG_DIR/${BSP}_config.log.old" || true
	mv "$LOG_DIR/${BSP}_build.log" "$LOG_DIR/${BSP}_build.log.old"
fi

mkdir -p "${BUILDDIR}"
pushd "${BUILDDIR}"
time ../../src/rtems/configure						\
	--target="${ARCH}-rtems${RTEMS_VER}"			\
	--enable-rtemsbsp="${BSP}"						\
	--prefix="$HOME/Programming/rtems/${RTEMS_VER}"	\
	--enable-maintainer-mode						\
	${ENABLE_TESTS}									\
	${ENABLE_SMP} 2>&1 | tee "$LOG_DIR/${BSP}_config.log"
make 2>&1 | tee "$LOG_DIR/${BSP}_build.log"
popd
