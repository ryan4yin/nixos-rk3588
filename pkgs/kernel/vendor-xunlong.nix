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

  # Path to the generated kernel config file
  #
  # To generate the config file, download the defconfig file from the above link to arch/arm64/configs/rk3588_xxx.config,
  # then run the following commands:
  #    make rk3588_xxx.config
  # and then copy the generated file(`.config`) to ./xxx_config in this directory.
  #
  #   make menuconfig        # view and modify the generated config file(.config) via Terminal UI
  #                          # input / to search, Ctrl+Backspace to delete.
  #
  # Manual configuration:
  #    - CONFIG_CRYPTO_USER_API_HASH is not enabled! (maybe needed by dm_crypt(LUKS))
  configfile = ./rk35xx_xunlong_config;
  allowImportFromDerivation = true;
})
.overrideAttrs (old: {
  name = "k"; # dodge uboot length limits
  nativeBuildInputs = old.nativeBuildInputs ++ [ubootTools];
})
