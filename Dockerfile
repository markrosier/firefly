FROM ubuntu:16.04
WORKDIR /app
USER root
RUN apt update
RUN apt-get -y install git gcc-arm-linux-gnueabihf u-boot-tools device-tree-compiler mtools \
parted libudev-dev libusb-1.0-0-dev python-linaro-image-tools linaro-image-tools libssl-dev \
autotools-dev libsigsegv2 m4 libdrm-dev curl sed make binutils build-essential gcc g++ bash \
patch gzip bzip2 perl tar cpio python unzip rsync file bc wget libncurses5 libglib2.0-dev openssh-client \
gcc-arm-linux-gnueabihf \
gcc-aarch64-linux-gnu device-tree-compiler lzop libncurses5-dev \
libssl1.0.0 libssl-dev \
p7zip
RUN git clone https://github.com/FireflyTeam/repo.git
WORKDIR /app/repo
RUN ./repo init --repo-url https://github.com/FireflyTeam/repo.git -u https://github.com/FireflyTeam/manifests.git -b linux-sdk -m rk3288/rk3288_linux_release.xml
RUN ./repo sync -c
WORKDIR /app 
RUN mkdir WORKDIR/Download
RUN curl https://drive.google.com/open?id=1dWm0rUpKHULXM9N-GfPNnBPqgjjY2LIJ  \ 
WORKDIR/Download
RUN p7zip -d WORKDIR/Download/Firefly-RK3288_xubuntu_210181031.7z \
WORKDIR/tools/linux/Linux_Pack_Firmware/rockdev
RUN cd WORKDIR/tools/Linux_Pack_Firmware/rockdev
RUN ./unpack.sh
RUN ./build.sh firefly-rk3288-ubuntu.mk
RUN export RK_KERNEL_DTS=rk3288-firefly
RUN ./build.sh