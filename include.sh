#!/bin/bash

rtems_init() {
	if [[ ${RTEMS_ACTIVE:-0} -ne 1 ]]; then
		echo "Please set up the RTEMS dev env via the rtems command first"
		exit 1
	else
		pushd "$HOME/Programming/rtems" &> /dev/null
	fi

	export RTEMS_LOG_DIR="$HOME/Programming/rtems/builds/logs"
	mkdir -p "$RTEMS_LOG_DIR"
}
