# UEFI

Here we describe how to use UEFI([edk2-rk3588]) to boot NixOS on RK3588/RK3588s based SBCs.

## 1. Flash [edk2-rk3588] to SPI NOR flash

> NOTE: Rock 5A seems do not have a SPI NOR flash, so you can skip this step directly.

To use UEFI to boot NixOS, you need to flash the UEFI firmware to the SPI NOR flash of the board.

The steps to do this:

1. Download the prebuilt UEFI firmware from [edk2-rk3588/releases](https://github.com/edk2-porting/edk2-rk3588/releases).
1. To flash the UEFI firmware to the SPI NOR flash, you need to:
   1. Boot the board with a Linux distro that supports your SBC, such as [armbian](https://www.armbian.com/download/) or your SBC's official image.
   1. Then use `dd` to flash the UEFI firmware you downloaded to the SPI flash:
   ```bash
   sudo dd if=./xxx-UEFI-xxx.img of=/dev/mtdblock0
   ```
1. Reboot the board, and you should see the UEFI boot menu.
1. In the UEFI boot menu
    1. Enter [Device Manager] => [Rockchip Platform Configuration] => [ACPI / Device Tree]
        1. Change [Config Table Mode] to `Both`.
        1. Change [Device Tree Configuration] => [Support DTB override & overlays] to `Enabled`.


## 2. Flash NixOS to SD card

This is the common way to flash NixOS to the board.

First, build the raw efi image:

> It will takes a long time(about 12mins) to finish, as we have to use the emulated system on x64 host to build the raw efi image.

```bash
# for orange pi 5
nix build .#rawEfiImage-opi5 --show-trace -L --verbose

# for orange pi 5 plus
nix build .#rawEfiImage-opi5plus --show-trace -L --verbose

# for rock 5a
nix build .#rawEfiImage-rock5a --show-trace -L --verbose
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

# please replace `/dev/sdX` with the correct device name of your sd card
cat result | sudo dd status=progress bs=8M of=/dev/sdX


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

> It's recommend to install your system into SSD / eMMC or a high-speed SD card, otherwise `nixos-install` may take a long time to finish.

It's also possible to install NixOS via `nixos-install`, this will give you a more flexible way to manage your system.
For example, you can use `nixos-install` to install NixOS with LUKS encryption, custom partition layout & filesystem, and with all your favorite packages pre-installed, etc.

To do this, you need to flash the image into the SD card and start into NixOS first, and then just follow the [official installation guide](https://nixos.org/manual/nixos/stable/#sec-installation-manual).

[edk2-rk3588]: https://github.com/edk2-porting/edk2-rk3588
