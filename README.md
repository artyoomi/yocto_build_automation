## Yocto Build Automation

This project is selection assignment for the "Yadro" laboratory at ETU "LETI" university.

### Usage
```sh
# Get poky and switch to kirkstone branch
git clone https://github.com/yoctoproject/poky -b kirkstone

# Build and run container
docker build -t yocto .
docker run -it --user $(id -u):$(id -g) --name yocto_cont -v $(pwd)/poky:/yocto/poky yocto COMMAND
```

### Task 
#### It is necessary to implement scripts and instructions for building an OS image (rootfs) in accordance with the following points
1. Get to know the Yocto Project: https://www.yoctoproject.org/.
Figure out how to set up the environment for building Yocto (poky distribution).
Assemble the simplest image (the goal is **core-image-minimal**). Make sure that it
runs in QEMU. Use the Yocto version: *Kirkstone*.
2. Implement build automation via Docker. In the container, it is necessary
to implement image assembly and image launch in QEMU. Choosing between assembly and
launching must be implemented through arguments passed to the container
at startup. It is best to use *docker volume* to collect all the source
files in a directory on the host machine (that is, the image is downloaded and assembled in
docker volume). Use ```ubuntu:20.04``` as the base Docker image.
3. Add the yadro_hello program to the image. The program should output the
string “Hello from my own program!” to the standard output stream. The program must be
written in C. The program must be added by creating a Yocto layer.
 
#### Requirements for completing the task:
- Build the OS image and run the QEMU VM inside the Docker container.
- You need to create your own repository for this task. The repository should contain
the source code files, dockerfile, scripts for building and running the job, and instructions
for starting and building
- For each task item, there should be an instruction on how
it is implemented and a command to reproduce it.
