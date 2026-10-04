# Example config for Orange Pi 5 Plus

This directory demonstrates how to make a system config and a bootable SD card image for Orange Pi 5 Plus
  using kernel and uboot from upstream nixpkgs.
The `flake.nix` defines the single system config `orangepi5plus` suitable for Pi 5 Plus,
  and the package `sdImage` that produces a bootable SD card image running `orangepi5plus` system.
You can use this as a starting configuration you customize to your needs,
  or adapt to a slightly different board (like Orange Pi 5) that is supported by Nixpkgs kernel and u-boot.

To boot your Pi 5 Plus with this config, do the following.

1. Modify the config as needed, run `nix build .#sdImage` in this directory.
2. Decompress and flash `./result/sd-image/*` into your SD card with `dd`.
3. Boot.

To rebuild on board:

4. Copy this directory to your board, modify as needed.
5. Run `sudo nixos-rebuild switch --flake .#orangepi5plus`.

## Structure

- `./configuration.nix` is for your personal preferences for services and users.
  Do not forget to edit the current example contents.
- `./hardware-configuration.nix` currently sets kernel version, drivers, parameters.
  Customize if needed.
- `./sdcard.nix` sets up SD card image parameters (partitions, board-specific u-boot firmware).
  Change this if you want different partitioning, e.g. with swap.

## Adapting to Orange Pi 5

Change `uboot = pkgs.ubootOrangePi5Plus;` to `uboot = pkgs.ubootOrangePi5;` in `./sdcard.nix`.
This should be sufficient to make a config for Orange Pi 5.
