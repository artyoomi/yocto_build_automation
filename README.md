## Yocto Build Automation

This project is selection assignment for the "Yadro" laboratory at ETU "LETI" university.

### Usage
```sh
# Get poky and switch to kirkstone branch
git clone https://github.com/yoctoproject/poky -b kirkstone

# Build and run container
docker build -t yocto-builder .
docker run -it --user $(id -u):$(id -g) -v $(pwd)/poky:/home/yocto/poky yocto-builder run
```

### Task 
It is necessary to implement scripts and instructions for building an OS image (rootfs) in accordance with the following points:
1. Get to know the Yocto Project: https://www.yoctoproject.org/.
Figure out how to set up the environment for building Yocto (Poky distribution).
Assemble the simplest image (the goal is core-image-minimal). Make sure that it
runs in QEMU. Use the Yocto version: Kirkstone.
2. Implement build automation via Docker. In the container, it is necessary
to implement image assembly and image launch in QEMU. Choosing between assembly and
before launching, it must be implemented through arguments passed to the container
at startup. It is best to use docker volume to collect all the source
files in a directory on the host machine (that is, the image is downloaded and assembled in
docker volume). Use: ubuntu as the base Docker image.:04/20.
3. Add the yadro_hello program to the image. The program should output the
string “Hello from my own program!” to the standard output stream. The program must be
written in C. The program must be added by creating a Yocto layer.
 
Requirements for completing the task:
- Build the OS image and run the QEMU VM inside the Docker container.
- You need to create your own repository for this task. The repository should contain
the source code files, dockerfile, scripts for building and running the job, and instructions
for starting and building
- For each task item, there should be an instruction on how
it is implemented and a command to reproduce it.

### Description

#### Structure of Dockerfile
0. Initialize some needed data
   ```Dockerfile
   FROM ubuntu:20.04

   ARG USERNAME=builder
   ARG APP_DIR=/home/$USERNAME

   WORKDIR $APP_DIR
   ```

1. Install the necessary dependencies for the build, as described [here](https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html)
   ```Dockerfile
   RUN apt update && \
       DEBIAN_FRONTEND=noninteractive \
       apt install -y build-essential \
                      chrpath \
                      cpio \
                      debianutils \
                      diffstat \
                      file \
                      gawk \
                      gcc \
                      git \
                      iputils-ping \
                      libacl1 \
                      liblz4-tool \
                      locales \
                      python3 \
                      python3-git \
                      python3-jinja2 \
                      python3-pexpect \
                      python3-pip \
                      python3-subunit \
                      socat \
                      texinfo \
                      unzip \
                      wget \
                      xz-utils \
                      zstd
   ```
   
2. Generate ```en_US.UTF-8``` locale
   ```Dockerfile
   RUN locale-gen en_US.UTF-8
   ```
   
4. Add new user with sudo rights
   ```Dockerfile
   RUN useradd -m $USERNAME && \
       apt install -y sudo && \
       usermod -aG sudo $USERNAME && \
       touch /etc/sudoers.d/${USERNAME}-nopasswd && \
       echo ${USERNAME} ALL=\(ALL\) NOPASSWD: ALL > /etc/sudoers.d/${USERNAME}-nopasswd && \
       chown $USERNAME:$USERNAME /home/$USERNAME
   ```
   
5. Switch to new user with
   ```Dockerfile
   USER ${USERNAME}
   ```
   
   
7. Copy necessary files in container
   ```Dockerfile
   COPY .env .
   COPY layers/ layers/
   COPY scripts/*.sh scripts/
   ```

8. Start *run_yocto.sh* script to provide selection between: build, run, bash
   ```Dockerfile
   ENTRYPOINT [ "bash", "scripts/run_yocto.sh" ]
   ```
   
   - *build*: to build image
     ```sh
     echo "Start building..."
     source oe-init-build-env

     # Add custom layer with add_layer.sh
     if ! [ -d "${PROJECT_DIR}/poky/meta-custom/" ]; then
     	echo ""
     	echo "Adding meta-custom layer..."
     	"${PROJECT_DIR}/scripts/add_layer.sh"
     	echo "meta-custom layer was succesfully added!"
     	echo "yadro-hello package was added to local.conf"
     	echo ""
	 fi

	 # Build core-image-minimal and yadro-hello (in a different way, yadro-hello can be added with IMAGE_INSTALL)
	 bitbake core-image-minimal
	 bitbake yadro-hello
     ```

   - *run*: check that image was already builded and try to run it
     ```sh
     if [ -d "build/tmp/deploy/images/qemux86-64" ]; then
	 	echo "Trying to run poky in qemu..."
	 	source oe-init-build-env build

     	# "slirp" used to enable different way of networking and "nographic" to disable video console.
 	 	runqemu "slirp" "nographic"
	 else
	 	echo "Image for qemux86-64 was not build, build it with \"build\" option!!!"
	 fi
     ```

   - *bash*: bash session to view container files

#### Adding new layer
To add new layer in image implemented add_layer.sh script from the scripts folder.
The logic of the script:
- Copy all layer files to poky directory (layer files is: .bb and .c file)
- Add new layer in bbconfig.conf with ```bitbake-layers add-layer```
