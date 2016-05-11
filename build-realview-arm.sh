#!/bin/bash

set -e
set -u
set -o pipefail

SC_DIR="$(dirname "$0")"

# Edit these values to build a different Arch / BSP
ARCH="arm"
BSP="realview_pbx_a9_qemu_smp"

# Edit these values to enable / disable some configure options
ENABLE_TESTS="-t"
ENABLE_SMP="-s"

bash "$SC_DIR/build-bsp.sh" -a $ARCH -b $BSP \
	${ENABLE_SMP:-""} \
	${ENABLE_TESTS:-""} \
	"$@"
