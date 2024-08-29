{
  lib,
  config,
  rk3588,
  ...
}: let
  rootPartitionUUID = "14e19a7b-0ae0-484d-9d54-43bd6fdc20c7";
	uboot = pkgs.callPackage ../../pkgs/u-boot-opi5/prebuilt.nix {};
in {
  imports = [
    "${rk3588.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
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

  # add some missing deviceTree in armbian/linux-rockchip:
  # orange pi 5b's deviceTree in armbian/linux-rockchip:
  #    https://github.com/armbian/linux-rockchip/blob/rk-5.10-rkr4/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5b.dts
  hardware = {
    deviceTree = {
      name = "rockchip/rk3588s-orangepi-5b.dtb";
      overlays = [
      ];
    };

    firmware = [];
  };

  sdImage = {
    inherit rootPartitionUUID;
    compressImage = true;

    # install firmware into a separate partition: /boot/firmware
    populateFirmwareCommands = ''
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./firmware
    '';
    # Gap in front of the /boot/firmware partition, in mebibytes (1024×1024 bytes).
    # Can be increased to make more space for boards requiring to dd u-boot SPL before actual partitions.
    firmwarePartitionOffset = 32;
    firmwarePartitionName = "BOOT";
    firmwareSize = 200; # MiB

    populateRootCommands = ''
      mkdir -p ./files/boot
    '';

    # ???
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
