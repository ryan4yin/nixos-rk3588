# NixOS on RK3588/RK3588s based SBCs

> :warning: Work in progress, use at your own risk...

A minimal flake that makes NixOS running on RK3588/RK3588s based SBCs.

![](_img/nixos-on-orangepi5.webp)

## TODO

| Singal Board Computer | minimal bootable image |     |
| --------------------- | ---------------------- | --- |
| Orange Pi 5           | :heavy_check_mark:     |     |
| Orange Pi 5 Plus      | :no_entry_sign:        |     |
| Rock 5A               | :no_entry_sign:        |     |

- [ ] build u-boot with nix
- [ ] support boot from emmc
- [ ] verify all the hardware features available by RK3588/RK3588s
    - [x] ethernet (rj45)
    - wifi/bluetooth
    - audio
    - [x] gpio
    - [x] uart/ttl
    - gpu(mali-g610)
    - npu
    - ...

## How to deploy this flake

1. You should get the uboot from the vendor and flash it to the SPI flash before doing anything NixOS
   1. [Armbian on Orange Pi 5](https://www.armbian.com/orange-pi-5/) as an example:
      1. download the image and flash it to a sd card first
      2. boot the board with the sd card, and then run `sudo armbian-install` to flash the uboot to the SPI flash(maybe named as `MTD devices`)
2. build an sdImage by `nix build`, and then flash it to a sd card using `dd`:
   ```shell
   nix build .#nixosConfigurations.orangepi5.config.system.build.sdImage
   sudo dd bs=8M if=result/nixos.img of=/dev/sda status=progress
   ```
3. insert the sd card to the board, and power on
4. resize the root partition to the full size of the sd card.
5. then having fun with NixOS

Once the system is booted, you can use `nixos-rebuild` to update the system.

## How this flake works

A complete Linux system typically consists of four components: U-Boot, the kernel, device tree, and the root file system (rootfs).

Among these, U-Boot, the kernel, and the device tree are hardware-related and require customization for different SBCs.
On the other hand, the majority of content in the rootfs is hardware-independent and can be shared across different SBCs.

Hence, the fundamental approach here is to use the hardware-specific components(U-Boot, kernel, and device tree) provided by the vendor(orangepi/rockpi/...), and combine them with the NixOS rootfs to build a comprehensive system.

Regarding RK3588/RK3588s, a significant amount of work has been done by Armbian on their kernel, and device tree.
Therefore, by integrating these components from Armbian with the NixOS rootfs, we can create a complete NixOS system.

The primary steps involved are:

1. Build U-Boot using this Flake.
   - Since no customization is required for U-Boot, it's also possible to directly use the precompiled U-Boot from Armbian or the hardware vendor.
2. Build the NixOS rootfs using this Flake, leveraging the kernel and device tree provided by Armbian.

Related Armbian projects:

- <https://github.com/armbian/build>
- <https://github.com/armbian/linux-rockchip>

## References

The projects that inspired me:

- [K900/nix](https://gitlab.com/K900/nix)
- [aciceri/rock5b-nixos](https://github.com/aciceri/rock5b-nixos)

And I also got a lot of help in the [NixOS on ARM Matrix group](https://matrix.to/#/#nixos-on-arm:nixos.org)!
