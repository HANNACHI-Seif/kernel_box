FROM ubuntu:22.04

ENV LC_CTYPE C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Install the necessary packages
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get upgrade
    
RUN apt-get install -y \ 
    build-essential jq strace ltrace curl wget \
    rubygems gcc dnsutils netcat-openbsd gcc-multilib

RUN apt-get install -y \
    net-tools neovim gdb gdb-multiarch python3 python3-pip python3-dev

RUN apt-get install -y \
    libssl-dev libffi-dev wget git make procps libpcre3-dev libdb-dev libxt-dev libxaw7-dev libcapstone4 libnuma1 liburing2

RUN apt-get install -y \
    file tmux \
    qemu-user bc bison flex libelf-dev cpio build-essential libssl-dev qemu-system-x86


# prevent the "externally managed" python error
RUN rm -rf /usr/lib/python3.12/EXTERNALLY-MANAGED

RUN pip3 install pwntools keystone-engine unicorn capstone ropper

# pwngdb
#RUN git clone https://github.com/pwndbg/pwndbg && cd pwndbg && ./setup.sh

# gef
RUN git clone https://github.com/bata24/gef.git && echo "source /gef/gef.py" >> /root/.gdbinit

RUN gem install one_gadget

RUN apt-get install -y gcc-arm-linux-gnueabihf libc6-armhf-cross libc6-mipsel-cross libc6-riscv64-cross

RUN mkdir /etc/qemu-binfmt && \
ln -s /usr/arm-linux-gnueabihf/ /etc/qemu-binfmt/arm && \
ln -s /usr/mipsel-linux-gnu/ /etc/qemu-binfmt/mipsel && \
ln -s /usr/riscv64-linux-gnu/ /etc/qemu-binfmt/riscv64

# docker build -t kernel_box .
# docker run --rm -v $PWD:/pwd --cap-add=SYS_PTRACE --privileged --security-opt seccomp=unconfined -d --name ctf -i kernel_box
# docker exec -it ctf /bin/bash

# inside the container: update-binfmts --enable
