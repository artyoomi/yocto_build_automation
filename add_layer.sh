#!/bin/bash
cd poky
source oe-init-build-env ~/build
cd ..
bitbake-layers create-layer meta-yadro_hello
cd build
bitbake-layers add-layer ../meta-yadro_hello
cd ..

cat compile_instr.txt > meta-yadro_hello/recipes-example/example/example_0.1.bb
cp yadro_hello.c meta-yadro_hello/recipes-example/example/
