# =========================================================================
#      Rock 5 Model A Specific Configuration
# =========================================================================
{ lib
, config
, pkgs
, rk3588
, ...
}:
let
  inherit (rk3588) nixpkgs;

  boardName = "rock5a";
  rootPartitionUUID = "14e19a7b-0ae0-484d-9d54-43bd6fdc20c7";
  # rkbin-rk3588 = pkgs.callPackage ../../pkgs/rkbin-rk3588 {};
  uboot = pkgs.callPackage ../../pkgs/u-boot/radxa-prebuilt.nix { };
in
{
  imports = [
    ./base.nix
    ../sd-image-rockchip.nix
    # "${nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
    "${nixpkgs}/nixos/modules/profiles/base.nix"
  ];

  boot = {
    kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ../../pkgs/kernel/legacy.nix { });

    # kernelParams copy from rock5a's official debian image's /boot/extlinux/extlinux.conf
    # https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
    kernelParams = [
      "root=UUID=${rootPartitionUUID}"
      "rootwait"
      "rootfstype=ext4"
      "rw" # load rootfs as read-write

      "earlycon" # enable early console, so we can see the boot messages via serial port / HDMI
      "consoleblank=0" # disable console blanking(screen saver)
      "console=tty0"
      "console=ttyAML0,115200n8"
      "console=ttyS0,1500000n8"
      "console=ttyS2,1500000n8"
      "console=ttyFIQ0,1500000n8"

      "coherent_pool=2M"
      "irqchip.gicv3_pseudo_nmi=0"

      # show boot logo
      "splash"
      "plymouth.ignore-serial-consoles"

      # docker optimizations
      "cgroup_enable=cpuset"
      "cgroup_memory=1"
      "cgroup_enable=memory"
      "swapaccount=1"
    ];
  };

  # add some missing deviceTree in armbian/linux-rockchip:
  # Rock 5 Model A's deviceTree in armbian/linux-rockchip:
  #    https://github.com/armbian/linux-rockchip/blob/rk-5.10-rkr4/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
  hardware = {
    deviceTree = {
      # https://github.com/radxa/overlays/blob/main/arch/arm64/boot/dts/rockchip/overlays/
      name = "rockchip/rk3588s-rock-5a.dtb";
      overlays = [
      ];
    };

    firmware = [
    ];
  };

  fileSystems = lib.mkForce {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  sdImage = {
    inherit rootPartitionUUID;

    imageBaseName = "${boardName}-sd-image";
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
