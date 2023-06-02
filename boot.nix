{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # FIXME: hack for util-linux issue, remove when fixed
  imports = [./hacks/old-kernel.nix];

  boot = {
    kernelPackages = let
      crossPkgs = pkgs.pkgsCross.aarch64-multiplatform;
    in
      crossPkgs.linuxPackagesFor (crossPkgs.callPackage ./hacks/kernel {
        src = inputs.linux-rockchip;
      });

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    initrd.includeDefaultModules = false;
  };

  hardware = {
    deviceTree = {
      name = "rockchip/rk3588s-orangepi-5.dtb";
      overlays = [
        {
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

    opengl = {
      enable = true;
      package =
        lib.mkForce
        (
          (pkgs.mesa.override {
            galliumDrivers = ["panfrost" "swrast"];
            vulkanDrivers = ["swrast"];
          })
          .overrideAttrs (_: {
            pname = "mesa-panfork";
            version = "23.0.0-panfork";
            src = inputs.mesa-panfork;
          })
        )
        .drivers;
    };

    firmware = [
      (pkgs.callPackage ./hacks/mali-firmware {})
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  nixpkgs.overlays = [
    (_: super: {makeModulesClosure = x: super.makeModulesClosure (x // {allowMissing = true;});})
  ];


  networking = {
    useDHCP = false;
    wireless.iwd = {
      enable = true;
      settings.General.Country = "CN";
    };
  };

  systemd.network = {
    enable = true;
    wait-online.anyInterface = true;

    networks = {
      wired = {
        name = "end1";
        DHCP = "yes";
        domains = ["home"];
      };

      wireless = {
        name = "wlan0";
        DHCP = "yes";
        domains = ["home"];
      };
    };
  };

  hardware.enableRedistributableFirmware = true;
  powerManagement.cpuFreqGovernor = "ondemand";

  system.build.sdImage = import "${inputs.nixpkgs}/nixos/lib/make-disk-image.nix" {
    name = "orangepi5-sd-image";
    copyChannel = false;
    inherit config lib pkgs;
  };
}
