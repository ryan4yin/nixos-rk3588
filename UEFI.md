# UEFI

Here we describe how to use UEFI([edk2-rk3588]) to boot NixOS on RK3588/RK3588s based SBCs.

## 1. Flash [edk2-rk3588] to SPI NOR flash

> NOTE: Rock 5A seems do not have a SPI NOR flash, so you can skip this step directly.

To use UEFI to boot NixOS, you need to flash the UEFI firmware to the SPI NOR flash of the board.

The steps to do this:

1. Download the prebuilt UEFI firmware from [edk2-rk3588/releases](https://github.com/edk2-porting/edk2-rk3588/releases).
2. To flash the UEFI firmware to the SPI NOR flash, you need to:
   1. Boot the board with a Linux distro that supports your SBC, such as [armbian](https://www.armbian.com/download/) or your SBC's official image.
   2. Then use `dd` to flash the UEFI firmware you downloaded to the SPI flash:

   ```bash
   sudo dd if=./xxx-UEFI-xxx.img of=/dev/mtdblock0
   ```

3. Reboot the board (taking the SD card out), and you should see the UEFI boot menu.

   > NOTE: On orangePi5plus which have 2 HDMI output, the UEFI will only be display on the first HDMI output, be sure to plug your monitor to the HDMI in the middle

4. In the UEFI boot menu
    1. Enter [Device Manager] => [Rockchip Platform Configuration] => [ACPI / Device Tree]
    2. Change [Config Table Mode] to `Both`.
    3. Change [Support DTB override & overlays] to `Enabled`.(see <https://github.com/ryan4yin/nixos-rk3588/issues/22> for more details)

## 2. Flash NixOS to SD card

This is the common way to flash NixOS to the board.

First, build the raw efi image:

> It will takes a long time(about 12mins) to finish, as we have to use the emulated system on x64 host to build the raw efi image.

```bash
# 1. Build using the qemu-emulated aarch64 environment or on Orange Pi 5 Plus itself.
# In this way, we can take advantage of the official build cache on NixOS to greatly speed up the build
# it takes about 40 minutes to build the image(mainly the kernel) on my Orange Pi 5 Plus.
# https://nixos.wiki/wiki/NixOS_on_ARM#Compiling_through_binfmt_QEMU
# for orange pi 5 plus
nix build github:gnull/nixos-rk3588#rawEfiImage-opi5plus --show-trace -L --verbose

# for orange pi 5
nix build github:gnull/nixos-rk3588#rawEfiImage-opi5 --show-trace -L --verbose

# for rock 5a
nix build github:gnull/nixos-rk3588#rawEfiImage-rock5a --show-trace -L --verbose
```

If you encounter issues like [`cannot allocate memory` despite free reporting "available"](https://stackoverflow.com/questions/46464785/cannot-allocate-memory-despite-free-reporting-available) when building the raw efi image, check your `dmesg`, and try to fix it via:

```bash
echo 1 > /proc/sys/vm/compact_memory
```

Then, flash the raw efi image to the board's SSD / SD card:

```bash
# ====================================
# For Orange Pi 5 & Orange Pi 5 Plus
# ====================================

# Please replace `/dev/sdX` with the correct device name of your sd card
cat result | sudo dd status=progress bs=8M of=/dev/sdX

# Due to https://github.com/ryan4yin/nixos-rk3588/issues/22
# We have to add our dtbs into edk2-rk3588's overlays folder `/boot/dtb/base`
# This is now done automatically as part of the rk3588-raw-efi format. See: modules/rk3588-raw-efi.nix

# ====================================
# For Rock 5A(Not Work Yet!!!)
#
# Rock 5A do not have a SPI NOR flash, so we have to flash UEFI and an OS on the same SD card!
#
# docs: https://github.com/edk2-porting/edk2-rk3588?tab=readme-ov-file#3-flash-the-firmware
# ====================================

## 1. mount the built image
cp result rock5a.img
sudo losetup --find --partscan rock5a.img
# $ lsblk | head
# NAME              MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
# loop0               7:0    0   3.8G  0 loop
# ├─loop0p1         259:6    0   236M  0 part
# └─loop0p2         259:7    0   3.6G  0 part

# disk to flash, please replace /dev/sdX with the correct device name of your sd card
DISK=/dev/sdX
## 2. flash UEFI into the SD card
sudo dd if=./rock-5a_UEFI_Release.img of=$DISK
### fix the partition table
echo w | sudo fdisk /dev/sdb
## 3. create a new partition(512M) and flash NixOS's boot partition into it.
### unit 's' - sectors(often 512 bytes = 1s)
LAST_SECTOR=$(sudo fdisk -l ${DISK} | grep ${DISK}1 | awk '{print $3}')
START=$((LAST_SECTOR + 1))
END=$((LAST_SECTOR + 2*1024*512))
sudo parted ${DISK} -- mkpart primary ${START}s ${END}s
sudo cat /dev/loop0p1 | sudo dd status=progress bs=8M of=${DISK}2
## 4. create a new partition(remaining) and flash NixOS's root partition into it.
LAST_SECTOR=$(sudo fdisk -l ${DISK} | grep ${DISK}2 | awk '{print $3}')
START=$((LAST_SECTOR + 1))
sudo parted ${DISK} -- mkpart primary ${START}s 100%
sudo cat /dev/loop0p2 | sudo dd status=progress bs=8M of=${DISK}3

# umount the image file
sudo losetup -d /dev/loop0
```

After the flash is complete, remove the SD card and reboot, you should see the UEFI boot menu.

## 3. Install NixOS into SSD / eMMC via `nixos-install`

> It's recommend to install your system into SSD / eMMC or a high-speed SD card, otherwise
> `nixos-install` may take a long time to finish.

It's also possible to install NixOS via `nixos-install`, this will give you a more flexible way to
manage your system. For example, you can use `nixos-install` to install NixOS with LUKS encryption,
custom partition layout & filesystem, and with all your favorite packages pre-installed, etc.

To do this, follow the steps below:

1. Do the work described earlier:
   1. Flash [edk2-rk3588] to SPI NOR flash.
   2. Flash NixOS to SD card
2. Get the NixOS system booted from UEFI
3. Follow the [official installation guide] to:
   1. Format & mount the target disk.
   2. Generate the NixOS configuration via `nixos-generate-config`.
4. Combine the generated configuration with the [demo configuration](./examples/demo) in this repo, finish
   all TODOs in the demo configuration.
5. Install NixOS via `nixos-install`, and verify the installation via `nixos-enter --root /mnt`, as
   the [official installation guide] described.
6. Remove the SD card and reboot, and NixOS should boot from the SSD / eMMC now.

> **NOTE**: The NixOS configuration generated by `nixos-generate-config` can't be used directly, as
> it lack some necessary configurations for your board, such as the vendor's kernel, device trees,
> gpu drivers, etc. The [demo configuration](./examples/demo) shows how to reference the necessary
> configurations from this repo, so that your NixOS system can boot and work correctly on your
> board.

[edk2-rk3588]: https://github.com/edk2-porting/edk2-rk3588
[official installation guide]: https://nixos.org/manual/nixos/stable/#sec-installation-manual
