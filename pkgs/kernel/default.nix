# args of buildLinux:
#   https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/kernel/generic.nix
# Note that this method will use the deconfig in source tree, 
# commbined the common configuration defined in pkgs/os-specific/linux/kernel/common-config.nix, which is suitable for a NixOS system.
# but it't not suitable for embedded systems, so we skip it.
# 
# 
# If you already have a generated configuration file, you can build a kernel that uses it with pkgs.linuxManualConfig
# The difference between deconfig and the generated configuration file is that the generated configuration file is more complete,
# 
{
  src,
  boardName,
  linuxManualConfig,
  ubootTools,
  ...
}:
(linuxManualConfig {
  version = "5.10.160-rockchip-rk3588";
  modDirVersion = "5.10.160";

  inherit src;
  
  # path to the generated kernel config file
  # 
  # you can generate the config file based on the orangepi_defconfig 
  # by running `make orangepi_defconfig` in the kernel source tree.
  # and then copy the generated file(`.config`) to ./light_config in the same directory of this file.
  # 
  #   make orangepi_defconfig   # generate the config file from orangepi_defconfig (the default config file)
  #   make menuconfig        # view and modify the generated config file(.config) via Terminal UI
  #                          # input / to search, Ctrl+Backspace to delete.
  configfile = ./. + "/${boardName}_config";

  extraMeta.branch = "5.10";

  allowImportFromDerivation = true;
})
.overrideAttrs (old: {
  name = "k"; # dodge uboot length limits
  nativeBuildInputs = old.nativeBuildInputs ++ [ubootTools];
})
