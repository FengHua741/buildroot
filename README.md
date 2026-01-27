# 明日方舟 电子通行证 Buildroot SDK

基于aodzip老师的buildroot-tiny200 发行版，更改rootfs文件系统为UBIFS，在Uboot层做了dtoverlay，并进行硬件解码相关的修补。

本buildroot是“四合一”buildroot，可以生成Kernel、U-boot、rootfs、epass_drm_app。

默认用户名：root 默认密码：toor

电子通行证文件相关位于：buildroot-epass/board/rhodesisland/epass目录下

## 如何构建系统
以下指令仅在ubuntu 24.04测试可用，如果您使用了其他发行版可能有所不同，请自行解决。

### 安装工具包
``` shell
sudo apt install wget unzip build-essential git bc swig libncurses-dev libpython3-dev libssl-dev mtd-utils
sudo apt install python3-distutils fakeroot
```

### 克隆本仓库
```shell
git clone https://github.com/inapp123/buildroot-epass
```

### 应用 defconfig

**请注意：应用defconfig会覆盖你之前的所有的配置！！**

**一般来说只需要应用一次**

```shell
cd buildroot-epass
make rhodesisland_epass_defconfig
```

### 构建
```shell
make
```
构建的结果在output/images中。其中：

* U-boot: u-boot-sunxi-with-nand-spl.bin
* Boot分区（包括kernel和设备树）: boot_ubi.img
* Rootfs（包括epass_drm_app等）: rootfs_ubi.img

### 重新构建内核及设备树
```shell
./rebuild-kernel.sh
```

### 重新构建U-boot
```shell
./rebuild-uboot.sh
```

### 直接烧录系统

需要先安装[XFEL](https://github.com/xboot/xfel)和dfu-util

首先准备bootenv.txt，内容为：

```
device_rev=0.3
screen=hsd
(这里加一个换行，然后加一个\\0x00)
```

> 注意：这里的device_rev和screen需要根据你的设备实际情况填写。
> device_rev: 0.2/0.3/0.5/0.6
> screen: boe/hsd/laowu

然后执行：
```shell
xfel spinand erase 0 0x8000000
xfel spinand write 0 u-boot-sunxi-with-nand-spl.bin
xfel spinand write 0xfa000 bootenv.txt
xfel reset

dfu-util -R -a boot -D boot_ubi.img
dfu-util -R -a rootfs -D rootfs_ubi.img
```

## 更新说明

当更新了epass_drm_app后，需要bump这里的buildroot package：

在package/epass_drm_app/epass_drm_app.mk中，将EPASS_DRM_APP_VERSION改为新的版本号。

# Buildroot Package for Allwinner SIPs
Opensource development package for Allwinner F1C100s & F1C200s

## Driver support
Check this file to view current driver support progress for F1C100s/F1C200s: [PROGRESS-SUNIV.md](PROGRESS-SUNIV.md)

Check this file to view current driver support progress for V3/V3s/S3/S3L: [PROGRESS-V3.md](PROGRESS-V3.md)

## Install

### Install necessary packages
``` shell
sudo apt install wget unzip build-essential git bc swig libncurses-dev libpython3-dev libssl-dev
sudo apt install python3-distutils
```

### Download BSP
**Notice: Root permission is not necessery for download or extract.**
```shell
git clone https://github.com/aodzip/buildroot-tiny200
```

## Make the first build
**Notice: Root permission is not necessery for build firmware.**

### Apply defconfig
**Caution: Apply defconfig will reset all buildroot configurations to default values.**

**Generally, you only need to apply it once.**
```shell
cd buildroot-tiny200
make widora_mangopi_r3_defconfig
```

### Regular build
```shell
make
```

## Speed up build progress

### Download speed
Buildroot will download sourcecode when compiling the firmware. You can grab a **TRUSTWORTHY** archive of 'dl' folder for speed up.

### Compile speed
If you have a multicore CPU, you can try
```
make -j ${YOUR_CPU_COUNT}
```
or buy a powerful PC for yourself.

## Flashing firmware to target
You can flash a board by Linux (Recommended) or Windows system.
### [Here is the manual.](flashutils/README.md)

## Helper Scripts
- rebuild-uboot.sh: Recompile U-Boot when you direct edit U-Boot sourcecode.
- rebuild-kernel.sh: Recompile Kernel when you direct edit Kernel sourcecode.
- emulate-chroot.sh: Emulate target rootfs by chroot.
