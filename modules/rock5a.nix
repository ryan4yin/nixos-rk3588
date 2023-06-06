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

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    initrd.includeDefaultModules = false;
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


    # # TODO driver for Mali-G610 GPU
    # opengl = {
    #   enable = true;
    #   package =
    #     lib.mkForce
    #     (
    #       (pkgs.mesa.override {
    #         galliumDrivers = ["panfrost" "swrast"];
    #         vulkanDrivers = ["swrast"];
    #       })
    #       .overrideAttrs (_: {
    #         pname = "mesa-panfork";
    #         version = "23.0.0-panfork";
    #         src = inputs.mesa-panfork;
    #       })
    #     )
    #     .drivers;
    # };

    # # firmware for Mali-G610 GPU
    # firmware = [
    #   (pkgs.callPackage ../pkgs/mali-firmware {})
    # ];
  };

  # Some filesystems (e.g. zfs) have some trouble with cross (or with BSP kernels?) here.
  boot.supportedFilesystems = lib.mkForce [
    "vfat"
    "fat32"
    "exfat"
    "ext4"
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  # # allow missing modules, only enable this for testing!
  # nixpkgs.overlays = [
  #   (_: super: {makeModulesClosure = x: super.makeModulesClosure (x // {allowMissing = true;});})
  # ];


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

  # build an SD image
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/make-disk-image.nix
  system.build.sdImage = import "${modulesPath}/../lib/make-disk-image.nix" {
    name = "rock5a-sd-image";
    copyChannel = false;
    inherit config lib pkgs;
  };
}
