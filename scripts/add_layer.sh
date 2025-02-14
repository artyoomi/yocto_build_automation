#!/bin/bash

set -e

# Init poky build environment
cd "${PROJECT_DIR}/poky/build"

# Add new layer in poky directory
cp -r "${PROJECT_DIR}/layers/meta-custom" ..

# Add meta-custom to bblayer.conf
bitbake-layers add-layer ../meta-custom

# Add yadro-hello program to loca.conf
echo "IMAGE_INSTALL:append = \" yadro-hello\"" >> "${PROJECT_DIR}/poky/build/conf/local.conf"
