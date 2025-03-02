#!/bin/bash

# To exit from script when error occured
set -e

# Export necessary environment variables
source .env

cd "${PROJECT_DIR}"/poky

if [ "$1" == "run" ]; then
  if [ -d "build/tmp/deploy/images/qemux86-64" ]; then
	  echo "Trying to run poky in qemu..."
	  source oe-init-build-env build
 		runqemu "slirp" "nographic"
	else
	  echo "Image for qemux86-64 was not build, build it with \"build\" option!!!"
	fi
elif [ "$1" == "build" ]; then
	echo "Start building..."
	source oe-init-build-env

	# Add meta-custom if not added
	if ! [ -d "${PROJECT_DIR}/poky/meta-custom/" ]; then
		echo ""
		echo "Adding meta-custom layer..."
		"${PROJECT_DIR}/scripts/add_layer.sh"
		echo "meta-custom layer was succesfully added!"
		echo "yadro-hello package was added to local.conf"
		echo ""
	fi

	bitbake core-image-minimal
	bitbake yadro-hello
elif [ "$1" == "bash" ]; then
	bash
else
	echo "Usage: $0 [build | run | bash]"
	exit 1
fi
