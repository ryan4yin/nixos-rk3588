{
  lib,
  config,
  pkgs,
  rk3588,
  ...
}: let
  inherit (rk3588) nixpkgs;

  rootPartitionUUID = "14e19a7b-0ae0-484d-9d54-43bd6fdc20c7";
  # rkbin-rk3588 = pkgs.callPackage ../../pkgs/rkbin-rk3588 {};
  uboot = pkgs.callPackage ../../pkgs/u-boot-radxa/prebuilt.nix {};
in {
  imports = [
    ./sd-image-rock5a.nix
    # "${nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
    "${nixpkgs}/nixos/modules/profiles/base.nix"
  ];

  boot = {
    kernelParams = [
      "root=UUID=${rootPartitionUUID}"
      "rootfstype=ext4"
    ];

    loader = {
      grub.enable = lib.mkForce false;
      generic-extlinux-compatible.enable = lib.mkForce true;
    };
  };

  fileSystems = lib.mkForce {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  sdImage = {
    inherit rootPartitionUUID;

    compressImage = true;

    firmwarePartitionOffset = 32;
    populateFirmwareCommands = "";

    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';

    # https://opensource.rock-chips.com/wiki_Boot_option
    # image location(sector): 0x40 - idbloader.img, pre-loader
    # image location(sector): 0x4000 - u-boot.img, including u-boot and atf.
    postBuildCommands = ''
      # puts the Rockchip header and SPL image first at block 64 (0x40)
      dd if=${uboot}/idbloader.img of=$img seek=64 conv=notrunc
      # places the U-Boot image at block 16384 (0x4000)
      dd if=${uboot}/u-boot.itb of=$img seek=16384 conv=notrunc
    '';
  };
}
