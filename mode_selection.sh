#!/bin/bash

if [ "$mode" = "run" ]; then
	echo "Running poky build..."
	runqemu qemux86-64
elif [ "$mode" = "build" ]; then
	echo "Build option was chosen"
	cd build
	bitbake core-image-minimal
else
	echo "Unknown mode"
fi
