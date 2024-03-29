#!/bin/bash

if [ "$mode" = "run" ]; then
	echo "Running poky build..."
	cd poky/build
	runqemu qemux86 ramfs slirp nographic
elif [ "$mode" = "build" ]; then
	echo "Build option was chosen"
	if ! [ -d poky/build ]; then
		source add_layer.sh
		cd poky/build
		bitbake core-image-minimal
	else
		echo "Warning: Project already wad builded"
	fi
else
	echo "Unknown mode"
	exit 1
fi

