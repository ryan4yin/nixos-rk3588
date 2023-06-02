# NixOS on Orange Pi 5 / Orange Pi 5 Plus

> :warning: WIP 项目仍在开发中，请自行评估使用风险...

参考过的配置：

- [K900/nix](https://gitlab.com/K900/nix)
- [aciceri/rock5b-nixos](https://github.com/aciceri/rock5b-nixos).

## TODO

- [ ] Build a minimal bootable image w, with the vendor's uboot and kernel.
- [ ] Make the image more useful by adding supports for gpu/gpio/audio/...

## 思路

一个简单的 Linux 或者说嵌入式系统启动和运行一般遵循的规律是：

```mermaid
graph LR
  a[启动加电] --> b[spl 和 u-boot 部分] -->  c[内核镜像启动] --> d[挂载根目录启动完整操作系统]
```

> 这里把 spl 跟 u-boot 看作了一个整体，它们类似于 x86 的 bios/uefi

这样的启动流程有利于用户和玩家基于目前已有情况，减少折腾重构系统繁杂过程，直接在此基础上开始构建一个全新的发行版。

比如说我现在想要将 NixOS 跑在 Orange Pi 5 上，但是板子用到的 SoC 在主线内核上还没有很好的支持，那就需要将如下几个部分组合起来：

- SBC/SoC 厂商提供的 u-boot 与 Linux Kernel，它们都基于 SoC 跟开发板外设的特性进行了定制
  - 或者用第三方社区维护的 u-boot 和 Linux Kernel，比如 Armbian 的 u-boot 和 Linux Kernel 就兼容了众多 ARM 开发板
- SBC/SoC 厂商提供的各种外设的内核模块（驱动），比如 GPU、GPIO、Audio 等
- NixOS 的 rootfs

目前 armbian 对 rk3588/rk3588s 两个 SoC 平台，以及 Orange Pi 5 的支持都挺完善了，所以大概的选择如下：

- Linux 内核：[armbian/linux-rockchip/rk-5.10-rkr4](https://github.com/armbian/linux-rockchip/tree/rk-5.10-rkr4)
-

## 学习路线

1. 交叉编译: https://nix.dev/tutorials/cross-compilation
2. 构建 ISO 镜像: https://nix.dev/tutorials/nixos/build-and-deploy/building-bootable-iso-image
3. 使用 nixos-generator 生成系统镜像： https://github.com/nix-community/nixos-generators

## 名词或工具

### 1. [binfmt](https://github.com/tonistiigi/binfmt) 容器

> https://www.cnblogs.com/frankming/p/16870285.html

binfmt_misc 是 Linux 内核的一项功能，全称是混杂二进制格式的内核支持（Kernel Support for miscellaneous Binary Formats），它能够使 Linux 支持运行几乎任何格式的程序，包括编译后的 Java、Python 或 Emacs 程序。

为了能够让 binfmt_misc 运行任意格式的程序，至少需要做到两点：特定格式二进制程序的识别方式，以及其对应的解释器位置。虽然 binfmt_misc 听上去很强大，其实现的方式却意外地很容易理解，类似于 bash 解释器通过脚本文件的第一行（如#!/usr/bin/python3）得知该文件需要通过什么解释器运行，binfmt_misc 也预设了一系列的规则，如读取二进制文件头部特定位置的魔数，或者根据文件扩展名（如.exe、.py）以判断可执行文件的格式，随后调用对应的解释器去运行该程序。Linux 默认的可执行文件格式是 elf，而 binfmt_misc 的出现拓宽了 Linux 的执行限制，将一点展开成一个面，使得各种各样的二进制文件都能选择它们对应的解释器执行。

注册一种格式的二进制程序需要将一行有 `:name:type:offset:magic:mask:interpreter:flags` 格式的字符串写入 `/proc/sys/fs/binfmt_misc/register` 中，格式的详细解释这里就略过了。

由于人工写入上述 binfmt_misc 的注册信息比较麻烦，社区提供了一个容器来帮助我们自动注册，这个容器就是 binfmt，运行一下该容器就能安装各种格式的 binfmt_misc 模拟器了，举个例子：

```shell
# 注册所有架构
podman run --privileged --rm tonistiigi/binfmt:latest --install all

# 仅注册常见的 arm/riscv 架构
docker run --privileged --rm tonistiigi/binfmt --install arm64,riscv64,arm
```

binfmt_misc 模块自 Linux 2.6.12-rc2 版本中引入，先后经历了几次功能上的略微改动。
Linux 4.8 中新增“F”（fix binary，固定二进制）标志位，使 mount 命名空间变更和 chroot 后的环境中依然能够正常调用解释器执行二进制程序。由于我们需要构建多架构容器，必须使用“F”标志位才能 binfmt_misc 在容器中正常工作，因此内核版本需要在 4.8 以上才可以。

总的来说，比起一般情况显式调用解释器去执行非原生架构程序，binfmt_misc 产生的一个重要意义在于透明性。有了 binfmt_misc 后，用户在执行程序时不需要再关心要用什么解释器去执行，好像任何架构的程序都能够直接执行一样，而可配置的“F”标志位更是锦上添花，使解释器程序在安装时立即就被加载进内存，后续的环境改变也不会影响执行过程。

### 2. [systemd-nspawn](https://wiki.archlinuxcn.org/wiki/Systemd-nspawn)

> https://wiki.archlinuxcn.org/wiki/Systemd-nspawn

systemd-nspawn 跟 chroot 命令类似，是个终极版的 chroot。

systemd-nspawn 将容器中各种内核接口的访问限制为只读，像是 /sys, /proc/sys 和 /sys/fs/selinux。网络接口和系统时钟不能从容器内更改，不能创建设备节点。不能从容器中重启宿主机，也不能加载内核模块。

相比 LXC 或 Libvirt， systemd-nspawn 更容易配置。

systemd-nspawn 是 systemd 的一部分并被打进 systemd 软件包中。

### 3. qemu-user

qemu 有两种运行模式：

1. user: 用于用户态程序的模拟，可运行跨架构的虚拟机，比如在 x86_64 上运行 arm 程序
2. system: 只能运行同架构的虚拟机，不过性能会好很多

### 4. udev 规则

udev 是 Linux kernel 的设备管理器，用于管理 /dev 目录底下的设备文件。

动态管理：
当设备添加/删除时，udev 的守护进程侦听来自内核的 uevent，以此添加或者删除 /dev 下的设备文件，
所以 udev 只为已经连接的设备产生设备文件，而不会在 /dev 下产生大量虚无的设备文件。

udev 能通过定义一个 udev 规则 (rule) 来自定义设备文件的属性，
这些设备属性可以是内核设备名称、总线路径、厂商名称、型号、序列号或者磁盘大小等等。

### 5. 如何在 flake 中实现交叉编译

> https://discourse.nixos.org/t/how-do-i-cross-compile-my-own-package-rather-than-something-in-nix-pkgs/19851/2

First you need to separate your nix file in two files, one that does callPackage on the other:
default.nix:

```nix
{ pkgs ? import <nixpkgs> {} }:
   pkgs.callPackage ./myapp.nix {}
```

and ./myapp.nix:

```nix
{ stdenv, SDL2 }: mkDerivation { ... }
```

Then check that it still builds. Then to cross compile, replace usage of `pkgs.callPackage` by `pkgs.pkgsCross.aarch64-linux.callPackage`.

Good luck :slight_smile:

这也正是这个项目中的用法，不过它还将 `pkgs.pkgsCross.aarch64-linux.callPackage` 重命名为了 `pkgsCross`：

```nix
let
    pkgsCross = import inputs.nixpkgs {
      localSystem = system;
      crossSystem = "aarch64-linux";
    };
in
 ...
```

或者这么写，效果是一样的：

```nix
let
    pkgsCross = pkgs.pkgsCross.aarch64-linux;
in
 ...
```

还能这么写（仅猜测哈）：

```nix
let
    pkgsCross = nixpkgs."${system}".pkgsCross.aarch64-linux;
in
 ...
```

这样就可以直接用 `pkgsCross.callPackage` 了。

## 参考

- [LicheePi 4A —— 这个小板有点意思（第一部分）- by huguo](https://litterhougelangley.club/blog/2023/05/27/licheepi-4a-%e8%bf%99%e4%b8%aa%e5%b0%8f%e6%9d%bf%e6%9c%89%e7%82%b9%e6%84%8f%e6%80%9d%ef%bc%88%e7%ac%ac%e4%b8%80%e9%83%a8%e5%88%86%ef%bc%89/)
- [orangepi-xunlong/orangepi-build](https://github.com/orangepi-xunlong/orangepi-build/tree/next)
