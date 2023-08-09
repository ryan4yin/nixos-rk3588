# =========================================================================
#      Orange Pi 5 Specific Configuration
# =========================================================================
{
  config,
  pkgs,
  inputs,
  ...
}: 

let
  boardName = "orangepi5";
  rootPartitionUUID = "14e19a7b-0ae0-484d-9d54-43bd6fdc20c7";
in
{
  imports = [
    ./base.nix
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];

  boot = {
    kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ../pkgs/kernel/legacy.nix {});
  };

  # add some missing deviceTree in armbian/linux-rockchip:
  # orange pi 5's deviceTree in armbian/linux-rockchip:
  #    https://github.com/armbian/linux-rockchip/blob/rk-5.10-rkr4/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dts
  hardware = {
    deviceTree = {
      name = "rockchip/rk3588s-orangepi-5.dtb";
      overlays = [
        {
          # disable pcie2x1l2 (NVMe), and enable sata0
          name = "orangepi5-sata-overlay";
          dtsText = ''
            // Orange Pi 5 Pcie M.2 to sata
            /dts-v1/;
            /plugin/;

            / {
              compatible = "rockchip,rk3588s-orangepi-5";

              fragment@0 {
                target = <&sata0>;

                __overlay__ {
                  status = "okay";
                };
              };

              fragment@1 {
                target = <&pcie2x1l2>;

                __overlay__ {
                  status = "disabled";
                };
              };
            };
          '';
        }

        # enable i2c1
        {
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

    # TODO flash u-boot into sdImage.
    # dd if=\${orangepi5-uboot}/idbloader.img of=$img seek=64 conv=notrunc 
    # dd if=\${orangepi5-uboot}/u-boot.itb of=$img seek=16384 conv=notrunc
    populateRootCommands = ''
      mkdir -p ./files/boot
    '';
  };
}
