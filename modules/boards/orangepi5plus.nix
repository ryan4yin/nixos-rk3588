# =========================================================================
#      Orange Pi 5 Plus Specific Configuration
# =========================================================================
{
  config,
  pkgs,
  inputs,
  ...
}: 

let
  boardName = "orangepi5plus";
  rootPartitionUUID = "14e19a7b-0ae0-484d-9d54-43bd6fdc20c7";
in
{
  imports = [
    ./base.nix
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];

  boot = {
    kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ../../pkgs/kernel/legacy.nix {});

    # kernelParams copy from Armbian's /boot/armbianEnv.txt & /boot/boot.cmd
    kernelParams = [
      "root=UUID=${rootPartitionUUID}"
      "rootwait"
      "rootfstype=ext4"

      "earlycon"  # enable early console, so we can see the boot messages via serial port / HDMI
      "consoleblank=0"  # disable console blanking(screen saver)
      "console=ttyS2,1500000" # serial port
      "console=tty1"          # HDMI

      # docker optimizations
      "cgroup_enable=cpuset"
      "cgroup_memory=1"
      "cgroup_enable=memory"
      "swapaccount=1"
    ];
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