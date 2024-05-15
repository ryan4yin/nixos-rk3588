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
  version = "${modDirVersion}-radxa-rk3588";
  extraMeta.branch = "6.1";

  # https://github.com/radxa/kernel/tree/linux-6.1-stan-rkr1
  # build script:
  #   https://github.com/radxa/build/blob/debian/board_configs.sh
  src = fetchFromGitHub {
    owner = "radxa";
    repo = "kernel";
    rev = "e9a18501650dfd9743e55d7079db5c0face8f1cd";
    hash = "sha256-TYf9PntAXd8JXZ1CD0z584leOmfkCZGIyT9DyvO0LiQ=";
  };

  # Steps to the generated kernel config file
  #  0. mkdir outputs & cd outputs
  #  1. git clone --depth 1 https://github.com/radxa/kernel.git -b linux-6.1-stan-rkr1 radxa-kernel
  #  2. run `nix develop .#fhsEnv` in this project to enter the fhs test environment defined here.
  #  3. `cd radxa-kernel` and `make rockchip_linux_defconfig` to configure the kernel.
  #  4. Then use `make menuconfig` in kernel's root directory to view and customize the kernel(like enable/disable rknpu, rkflash, ACPI(for UEFI) etc).
  #  5. copy the generated .config to ./pkgs/kernel/rk35xx_radxa_config and commit it.
  #
  configfile = ./rk35xx_radxa_config;
  allowImportFromDerivation = true;
})
.overrideAttrs (old: {
  name = "k"; # dodge uboot length limits
  nativeBuildInputs = old.nativeBuildInputs ++ [ubootTools];
})
