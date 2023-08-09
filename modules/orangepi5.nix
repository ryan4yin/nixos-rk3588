# =========================================================================
#      Orange Pi 5 Specific Configuration
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
      boardName = "orangepi5";
    });
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

  # build SD image
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/make-disk-image.nix
  system.build.sdImage = import "${modulesPath}/../lib/make-disk-image.nix" {
    name = "orangepi5-sd-image";
    copyChannel = false;
    inherit config lib pkgs;
  };
}
