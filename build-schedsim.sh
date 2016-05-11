#!/bin/bash

set -e
set -u
set -o pipefail
# set -x

SC_DIR="$(dirname "$0")"
source "$SC_DIR/include.sh"
rtems_init

if [ ! -r src/rtems-schedsim/configure ] ; then
	echo "rtems-schedsim is not bootstrapped"
	exit 1
fi

rm -rf builds/rtems-schedsim
mkdir -p builds/rtems-schedsim
pushd builds/rtems-schedsim

#SMP="--disable-smp"
SMP="--enable-smp"

DEBUG="--enable-rtems-debug"
# DEBUG=""

COV="--coverage"
#COV=

# Now invoke configure and make using the arguments selected
../../src/rtems-schedsim/configure \
	CFLAGS_FOR_BUILD="-O0 -fno-inline -g ${COV}" \
	CXXFLAGS_FOR_BUILD="-O0 -fno-inline -g ${COV}" \
	${SMP} ${DEBUG} \
	--enable-rtemsdir=${HOME}/Programming/rtems/src/rtems \
	--prefix=${HOME}/Programming/rtems/builds/rtems-schedsim \
	--enable-maintainer-mode \
	2>&1 | tee c.log

make -v -j1 2>&1 | tee b.log

make check 2>&1 | tee check.log
