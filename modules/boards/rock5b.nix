# =========================================================================
#      Rock 5 Model B Specific Configuration
# =========================================================================
{rk3588, ...}: let
  pkgsKernel = rk3588.pkgsKernel;
in {
  imports = [
    ./base.nix
  ];

  boot = {
    kernelPackages = pkgsKernel.linuxPackagesFor (pkgsKernel.callPackage ../../pkgs/kernel/vendor.nix {});

    # kernelParams copy from rock5b's official debian image's /boot/extlinux/extlinux.conf
    # https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
    kernelParams = [
      "rootwait"
      "rw" # load rootfs as read-write

      "earlycon" # enable early console, so we can see the boot messages via serial port / HDMI
      "consoleblank=0" # disable console blanking(screen saver)
      "console=tty0"
      "console=ttyFIQ0,1500000n8"
      "console=ttyAML0,115200n8" # I'm not sure about these three
      "console=ttyS0,1500000n8"
      "console=ttyS2,1500000n8"

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
  # Rock 5 Model B's deviceTree in armbian/linux-rockchip:
  #    https://github.com/armbian/linux-rockchip/blob/rk-5.10-rkr4/arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts
  hardware = {
    deviceTree = {
      # https://github.com/radxa/overlays/blob/main/arch/arm64/boot/dts/rockchip/overlays/
      name = "rockchip/rk3588-rock-5b.dtb";
      overlays = [];
    };

    firmware = [];
  };
}
