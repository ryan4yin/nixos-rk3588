# U-Boot

Here we describe how to use U-Boot to boot NixOS on RK3588/RK3588s based SBCs.

## 1. Flash U-Boot to SPI NOR flash

You should get the uboot from the vendor and flash it to the SPI NOR flash before doing anything NixOS

1. Armbian on [Orange Pi 5](https://www.armbian.com/orange-pi-5/) / [Orange Pi 5 Plus](https://www.armbian.com/orange-pi-5-plus/) as an example:
   1. download the image and flash it to a sd card first
   2. boot the board with the sd card, and then run `sudo armbian-install` to flash the uboot to the SPI NOR flash(maybe named as `MTD devices`)

For Rock 5A, we've bundled the uboot into the sdImage, so you can skip this step directly.

## 2. Flash NixOS

There're two ways to flash NixOS to the board:

1. Flash NixOS to SD card
2. Flash NixOS into SSD/eMMC

## 2.1. Flash NixOS to SD card

This is the common way to flash NixOS to the board.

Build an sdImage by `nix build`, and then flash it to a SD card using `dd`(please replace `/dev/sdX` with the correct device name of your sd card):

<!-- > **Instead of build from source, you can also download the prebuilt image from [Releases](https://github.com/gnull/nixos-rk3588/releases)**. -->
> To understand how this flakes works, please read [Cross-platform Compilation](https://nixos-and-flakes.thiscute.world/development/cross-platform-compilation).

```bash
# ==================================
# For Orange PI 5 Plus
# ==================================
# 1. Build using the qemu-emulated aarch64 environment or on Orange Pi 5 Plus itself.
# In this way, we can take advantage of the official build cache on NixOS to greatly speed up the build
# it takes about 40 minutes to build the image(mainly the kernel) on my Orange Pi 5 Plus.
# https://nixos.wiki/wiki/NixOS_on_ARM#Compiling_through_binfmt_QEMU
nix build github:gnull/nixos-rk3588#sdImage-opi5plus

# 2. Build using the cross-compilation environment
# NOTE: This will take a long time to build, as the official build cache is not available for the cross-compilation environment,
# you have to build everything from scratch.
nix build github:gnull/nixos-rk3588#sdImage-opi5plus-cross

zstdcat result/sd-image/orangepi5plus-sd-image-*.img.zst | sudo dd status=progress bs=8M of=/dev/sdX

# ==================================
# For Orange PI 5
# ==================================
nix build github:gnull/nixos-rk3588#sdImage-opi5

nix build github:gnull/nixos-rk3588#sdImage-opi5-cross # fully cross-compiled


zstdcat result/sd-image/orangepi5-sd-image-*.img.zst | sudo dd status=progress bs=8M of=/dev/sdX
```

For Rock 5A, it requires a little more work to flash the image to the sd card:

<!-- > The prebuilt image has been repaired before uploading, so you can use it directly. -->

```shell
nix build .#sdImage-rock5a
zstd -d result/sd-image/rock5a-sd-image-*.img.zst -o rock5a.img

# increase img's file size
dd if=/dev/zero bs=1M count=16 >> rock5a.img
sudo losetup --find --partscan rock5a.img

nix shell nixpkgs#parted
## rock 5a's u-boot require to use gpt partition table, and the root partition must be the first partition!
## so we need to remove all the partitions on the sd card first
## and then recreate the root partition with the same start sector as the original partition 2
START=$(sudo fdisk -l /dev/loop0 | grep /dev/loop0p2 | awk '{print $2}')
sudo parted /dev/loop0 rm 1
sudo parted /dev/loop0 rm 2
sudo parted /dev/loop0 mkpart primary ext4 ${START}s 100%

# check rootfs's status, it's broken.
sudo fsck /dev/loop0p1

# umount the image file
sudo losetup -d /dev/loop0


# flash the image to the sd card
cat rock5a.img | sudo dd status=progress bs=8M of=/dev/sdX
```

1. Insert the sd card to the board, and power on
2. Resize the root partition to the full size of the sd card.
3. Then having fun with NixOS <3.

Once the system is booted, you can use `nixos-rebuild` to update the system.

## Flash NixOS into SSD/eMMC

To flash the image into the board's eMMC / SSD, you need to flash the image into the SD card and start into NixOS first, as SSD / eMMC is not easy to remove and connect to your host.

Then, use the following command to flash the image into the board's SSD / eMMC:

```bash
# upload the sdImage to the NixOS system on the board
scp result/sd-image/orangepi5-sd-image-*.img.zst  rk@<ip-of-your-board>:~/

# login to the board via ssh or serial port
ssh rk@<ip-of-your-board>

# check all the block devices
# you should see nvme0n1(SSD)
$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
mtdblock0    31:0    0    16M  0 disk
zram0       254:0    0     0B  0 disk
nvme0n1     259:0    0 238.5G  0 disk
......

# flash the image into the board's SSD
zstdcat orangepi5-sd-image-*.img.zst | sudo dd bs=4M status=progress of=/dev/nvme0n1
```

After the flash is complete, remove the SD card and reboot, and NixOS should boot from the SSD / eMMC now.
