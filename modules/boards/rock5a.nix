# =========================================================================
#      Rock 5 Model A Specific Configuration
# =========================================================================
{
  config,
  pkgs,
  inputs,
  ...
}: let
  boardName = "rock5a";
  rootPartitionUUID = "14e19a7b-0ae0-484d-9d54-43bd6fdc20c7";
in {
  imports = [
    ./base.nix
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];

  boot = {
    kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ../../pkgs/kernel/legacy.nix {});

    # kernelParams copy from rock5a's official debian image's /boot/extlinux/extlinux.conf
    # https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
    kernelParams = [
      "root=UUID=${rootPartitionUUID}"
      "rw"  # load rootfs as read-write

      "earlycon"  # enable early console, so we can see the boot messages via serial port / HDMI
      "consoleblank=0"  # disable console blanking(screen saver)
      "console=tty0"
      "console=ttyAML0,115200n8"
      "console=ttyS0,1500000n8"
      "console=ttyS2,1500000n8"
      "console=ttyFIQ0,1500000n8"

      "coherent_pool=2M"
      "irqchip.gicv3_pseudo_nmi=0"

      # show boot logo
      "splash plymouth.ignore-serial-consoles"

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
      # https://github.com/armbian/build/blob/main/config/boards/rock-5a.wip#L9C28-L9C28
      name = "rockchip/rk3588s-rock-5a.dtb";
      overlays = [
      ];
    };

    firmware = [
    ];
  };

  sdImage = {
    inherit rootPartitionUUID;

    imageBaseName = "${boardName}-sd-image";
    compressImage = true;

    # install firmware into a separate partition: /boot/firmware
    populateFirmwareCommands = ''
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./firmware
    '';
    firmwarePartitionOffset = 32;
    firmwarePartitionName = "BOOT";
    firmwareSize = 200; # MiB

    # TODO flash u-boot into sdImage.
    # dd if=\${orangepi5-uboot}/idbloader.img of=$img seek=64 conv=notrunc
    # dd if=\${orangepi5-uboot}/u-boot.itb of=$img seek=16384 conv=notrunc
    populateRootCommands = ''
      mkdir -p ./files/boot
    '';
  };
}
