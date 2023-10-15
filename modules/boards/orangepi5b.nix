# =========================================================================
#      Orange Pi 5B Specific Configuration
# =========================================================================
{
  config,
  pkgs,
  nixpkgs,
  ...
}: 

let
  boardName = "orangepi5b";
  rootPartitionUUID = "14e19a7b-0ae0-484d-9d54-43bd6fdc20c7";
in
{
  imports = [
    ./base.nix
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
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
  # orange pi 5b's deviceTree in armbian/linux-rockchip:
  #    https://github.com/armbian/linux-rockchip/blob/rk-5.10-rkr4/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5b.dts
  hardware = {
    deviceTree = {
      name = "rockchip/rk3588s-orangepi-5b.dtb";
      overlays = [
        {
          # enable i2c1
          name = "orangepi5-i2c-overlay";
          dtsText = ''
            /dts-v1/;
            /plugin/;

            / {
              compatible = "rockchip,rk3588s-orangepi-5";

              fragment@0 {
                target = <&i2c1>;

                __overlay__ {
                  status = "okay";
                  pinctrl-names = "default";
                  pinctrl-0 = <&i2c1m2_xfer>;
                };
              };
            };
          '';
        }
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

    populateRootCommands = ''
      mkdir -p ./files/boot
    '';
  };
}
