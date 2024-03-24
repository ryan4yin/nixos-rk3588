# args of buildLinux:
#   https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/kernel/generic.nix
# Note that this method will use the deconfig in source tree,
# commbined the common configuration defined in pkgs/os-specific/linux/kernel/common-config.nix, which is suitable for a NixOS system.
# but it't not suitable for embedded systems, so we comment it out.
# ================================================================
# If you already have a generated configuration file, you can build a kernel that uses it with pkgs.linuxManualConfig
# The difference between deconfig and the generated configuration file is that the generated configuration file is more complete,
#
{
  fetchFromGitHub,
  linuxManualConfig,
  ubootTools,
  ...
}:
(linuxManualConfig rec {
  modDirVersion = "6.1.43";
  version = "${modDirVersion}-xunlong-rk3588";
  extraMeta.branch = "6.1";

  # https://github.com/orangepi-xunlong/linux-orangepi/tree/orange-pi-6.1-rk35xx
  src = fetchFromGitHub {
    owner = "orangepi-xunlong";
    repo = "linux-orangepi";
    rev = "752c0d0a12fdce201da45852287b48382caa8c0f";
    hash = "sha256-tVu/3SF/+s+Z6ytKvuY+ZwqsXUlm40yOZ/O5kfNfUYc=";
  };



  # Steps to the generated kernel config file
  #  1. git clone --depth 1 https://github.com/armbian/linux-rockchip.git -b rk-6.1-rkr1
  #  2. put https://github.com/armbian/build/blob/main/config/kernel/linux-rk35xx-vendor.config to linux-rockchip/arch/arm64/configs/rk35xx_vendor_defconfig
  #  3. run `nix develop .#fhsEnv` in this project to enter the fhs test environment defined here.
  #  4. `cd linux-rockchip` and `make rk35xx_vendor_defconfig` to configure the kernel.
  #  5. Then use `make menuconfig` in kernel's root directory to view and customize the kernel(like enable/disable rknpu, rkflash, ACPI(for UEFI) etc).
  #  6. copy the generated .config to ./pkgs/kernel/rk35xx_vendor_config and commit it.
  # 
  configfile = ./rk35xx_vendor_config;
  allowImportFromDerivation = true;
})
.overrideAttrs (old: {
  name = "k"; # dodge uboot length limits
  nativeBuildInputs = old.nativeBuildInputs ++ [ubootTools];
})
