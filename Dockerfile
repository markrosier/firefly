FROM ubuntu:16.04
WORKDIR /app
USER root
RUN apt update
RUN apt -y install git gcc-arm-linux-gnueabihf u-boot-tools device-tree-compiler mtools \
parted libudev-dev libusb-1.0-0-dev python-linaro-image-tools linaro-image-tools libssl-dev \
autotools-dev libsigsegv2 m4 libdrm-dev curl sed make binutils build-essential gcc g++ bash \
patch gzip bzip2 perl tar cpio python unzip rsync file bc wget libncurses5 libglib2.0-dev \
openssh-client gcc-arm-linux-gnueabihf gcc-aarch64-linux-gnu device-tree-compiler lzop \
libncurses5-dev libssl1.0.0 libssl-dev 

RUN git clone https://github.com/FireflyTeam/repo.git
WORKDIR /app
RUN ./repo/repo init --repo-url https://github.com/FireflyTeam/repo.git -u \
	https://github.com/FireflyTeam/manifests.git -b linux-sdk -m rk3288/rk3288_linux_release.xml
RUN ./repo/repo sync -c

RUN export RK_KERNEL_DTS=rk3288-firefly

RUN ./build.sh firefly-rk3288.mk
RUN apt -y install genext2fs
RUN sed -i 's/^export RK_ROOTFS_IMG.*/export RK_ROOT_FS_IMG=rootfs\/ubuntu1604armhf-rootfs.img/' /app/device/rockchip/.BoardConfig.mk


WORKDIR /app
RUN ./build.sh uboot
RUN ./build.sh kernel
RUN apt -y install time
RUN ./build.sh buildroot rootfs
RUN apt -y install p7zip-full
RUN wget http://download.t-firefly.com/product/Rootfs/ubuntu1604armhf-rootfs.7z
RUN 7z x ubuntu1604armhf-rootfs.7z
RUN cp ubuntu1604armhf-rootfs.img rootfs/

RUN ./mkfirmware.sh

WORKDIR /app/tools/linux/Linux_Pack_Firmware/rockdev
RUN rm -f afptool
RUN wget https://github.com/radxa/rockchip-pack-tools/raw/master/afptool
RUN chmod +x afptool
RUN rm -f rkImageMaker
RUN wget https://github.com/Nu3001/rockdev/raw/master/rkImageMaker
RUN chmod +x rkImageMaker

RUN cp ./Image/parameter.txt ./parameter
RUN ./mkupdate.sh
       



      
      

