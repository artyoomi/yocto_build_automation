# Build poky core-image-minimal and start it in qemu if specified

FROM ubuntu:20.04

ARG USERNAME=yocto

# Update list of available packages and install all dependencies
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

# Set locale for build
RUN locale-gen en_US.UTF-8

# Add new sudo user to container
RUN useradd -m $USERNAME && \
    apt install -y sudo && \
    usermod -aG sudo $USERNAME && \
    touch /etc/sudoers.d/${USERNAME}-nopasswd && \
    echo ${USERNAME} ALL=\(ALL\) NOPASSWD: ALL > /etc/sudoers.d/${USERNAME}-nopasswd && \
    chown $USERNAME:$USERNAME /home/$USERNAME

# Specify user to work
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Copy all necessary files in container
COPY .env .
COPY layers/ layers/
COPY scripts/*.sh scripts/

# Start build or run in qemu
ENTRYPOINT [ "bash", "scripts/run_yocto.sh" ]
