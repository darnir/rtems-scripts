
# RTEMS Build Scripts

This repository contains a set of scripts I wrote to manage the daily workflow
in RTEMS. They all make certain assumptions about the directory structure and
environment in which they are executed.

## Directory Structure

The following is the directory structure I use. Only the paths relative to the
root "rtems" directory matter.

      1 rtems
      2 ├── 4.12
      3 │   ├── arm-rtems4.12
      4 │   ├── bin
      5 │   ├── include
      6 │   ├── lib
      7 │   ├── libexec
      8 │   ├── share
      9 │   └── sparc-rtems4.12
     10 ├── builds
     11 │   ├── logs
     12 │   ├── realview_pbx_a9_qemu_smp
     13 │   ├── rtems-schedsim
     14 │   └── sis
     15 ├── scripts
     16 └── src
     17     ├── newlib-cygwin
     18     ├── rtems
     19     ├── rtems-schedsim
     20     └── rtems-source-builder

## Environment

The scripts expect that the following Environment variables are set:

```sh
RTEMS_ACTIVE=1
RTEMS_VER={Version of RTEMS to build}
```

These variables and the Python2 Virtualenv are set using the rtems() bash
function available at: https://github.com/darnir/dotfiles/blob/master/Packages/Bash/bash_functions#L363

