#!/bin/bash

dd if=/dev/zero of=$2 bs=1K count=$3
dd if=$1 of=$2 conv=notrunc
