# =========================================================================
#      Orange Pi 5 Plus Specific Configuration
# =========================================================================
{
  pkgs,
  rk3588,
  ...
}: let
  pkgsKernel = rk3588.pkgsKernel;
in {
  imports = [
    ./base.nix
    ./dtb-install.nix
  ];

  boot = {
    kernelPackages = pkgsKernel.linuxPackagesFor (pkgsKernel.callPackage ../../pkgs/kernel/vendor.nix {});

    # kernelParams copy from Armbian's /boot/armbianEnv.txt & /boot/boot.cmd
    kernelParams = [
      "rootwait"

      "earlycon" # enable early console, so we can see the boot messages via serial port / HDMI
      "consoleblank=0" # disable console blanking(screen saver)
      "console=ttyS2,1500000" # serial port
      "console=tty1" # HDMI

      # docker optimizations
      "cgroup_enable=cpuset"
      "cgroup_memory=1"
      "cgroup_enable=memory"
      "swapaccount=1"
    ];
  };

  hardware = {
    deviceTree = {
      name = "rockchip/rk3588s-orangepi-5-pro.dtb";
      overlays = [
      ];
    };

    firmware = [
      (pkgs.callPackage ../../pkgs/orangepi-firmware {})
    ];
  };
}
