# =========================================================================
#      Orange Pi 5 Plus Specific Configuration
# =========================================================================
{
  config,
  lib,
  pkgs,
  inputs,
  modulesPath,
  ...
}: 

{
  imports = [
    ./base.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ../pkgs/kernel {
      src = inputs.kernel-rockchip;
      stdenv = pkgs.gcc11Stdenv;
      boardName = "orangepi5plus";
    });
  };

  # add some missing deviceTree in armbian/linux-rockchip:
  # orange pi 5 plus's deviceTree in armbian/linux-rockchip:
  #    https://github.com/armbian/linux-rockchip/blob/rk-5.10-rkr4/arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-plus.dts
  hardware = {
    deviceTree = {
      # https://github.com/armbian/build/blob/f9d7117/config/boards/orangepi5-plus.wip#L10C51-L10C51
      name = "rockchip/rk3588-orangepi-5-plus.dtb";
      overlays = [
      ];
    };

    firmware = [
    ];
  };

  # build SD image
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/make-disk-image.nix
  system.build.sdImage = import "${modulesPath}/../lib/make-disk-image.nix" {
    name = "orangepi5plus-sd-image";
    copyChannel = false;
    inherit config lib pkgs;
  };
}
