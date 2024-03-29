#!/bin/bash
cd poky
source oe-init-build-env
cd ../..
bitbake-layers create-layer meta-yadro_hello

mkdir meta-yadro_hello/recipes-example/example/files
mv yadro_hello.c meta-yadro_hello/recipes-example/example/files/yadro_hello.c
cat compile_instr.txt > meta-yadro_hello/recipes-example/example/example_0.1.bb

cd poky/build
bitbake-layers add-layer ../../meta-yadro_hello
cd ../..
