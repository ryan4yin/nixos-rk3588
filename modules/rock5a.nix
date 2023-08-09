# =========================================================================
#      Rock 5 Model A Specific Configuration
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
      boardName = "rock5a";
    });
  };

  # add some missing deviceTree in armbian/linux-rockchip:
  # Rock 5 Model A's deviceTree in armbian/linux-rockchip:
  #    https://github.com/armbian/linux-rockchip/blob/rk-5.10-rkr4/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
  hardware = {
    deviceTree = {
      # https://github.com/armbian/build/blob/main/config/boards/rock-5a.wip#L9C28-L9C28
      name = "rockchip/rk3588s-rock-5a.dtb";
      overlays = [
      ];
    };

    firmware = [
    ];
  };

  # build an SD image
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/make-disk-image.nix
  system.build.sdImage = import "${modulesPath}/../lib/make-disk-image.nix" {
    name = "rock5a-sd-image";
    copyChannel = false;
    inherit config lib pkgs;
  };
}
