# NixOS on Orange Pi 5 / Orange Pi 5 Plus

> :warning: Work in progress, use at your own risk...

## how to deploy this flake

1. You should get the uboot from the vendor or Armbian and flash it to the SPI flash before doing anything NixOS
   1. [Armbian on Orange Pi 5](https://www.armbian.com/orange-pi-5/) as an example:
      1. download the image and flash it to a sd card first
      2. boot the board with the sd card, and then run `sudo armbian-install` to flash the uboot to the SPI flash(maybe named as `MTD devices`)
2. build an sdImage by `nix build`, and then flash it to a sd card using `dd`:
   ```shell
   nix build .#nixosConfigurations.orangepi5.config.system.build.sdImage
   sudo dd bs=8M if=result/nixos.img of=/dev/sda status=progress
   ```
3. insert the sd card to the board, and power on, then having fun with NixOS.

once the system is booted, you can use `nixos-rebuild` to update the system.

## time to build the image

running on i5-13600kf, with 32G ram, and a nvme ssd.

1. with emulated system: 1h 25m
2. with cross compilation: - (TODO)

## TODO

| Singal Board Computer | minimal bootable image |
| --------------------- | ---------------------- |
| Orange Pi 5           | :heavy_check_mark:     |
| Orange Pi 5 Plus      | :no_entry_sign:        |
| Rock 5A               | :no_entry_sign:        |

## References

The projects that inspired me:

- [K900/nix](https://gitlab.com/K900/nix)
- [aciceri/rock5b-nixos](https://github.com/aciceri/rock5b-nixos)
