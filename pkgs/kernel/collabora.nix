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
  fetchzip,
  linuxManualConfig,
  ubootTools,
  ...
}:
(linuxManualConfig {
  version = "6.5-collabora-rk3588";
  modDirVersion = "6.5.0";

  src = fetchzip {
    # branch: rk3588
    # date: 2023-07-21
    url = "https://gitlab.collabora.com/hardware-enablement/rockchip-3588/linux/-/archive/7a5aac740d804bf907bb3781c011a051fdcabd7e/linux-7a5aac740d804bf907bb3781c011a051fdcabd7e.zip";
    sha256 = "";
  };

  # Path to the generated kernel config file
  #
  # You can generate the kernel config file based on the defconfig.
  # Default config provided by armbian:
  #    https://github.com/armbian/build/blob/main/config/kernel/linux-rk35xx-legacy.config
  # To generate the config file, download the defconfig file from the above link to arch/arm64/configs/xxx_defconfig,
  # then run the following commands:
  #    make xxx_defconfig
  # and then copy the generated file(`.config`) to ./boardName_config in this directory.
  #
  #   make menuconfig        # view and modify the generated config file(.config) via Terminal UI
  #                          # input / to search, Ctrl+Backspace to delete.
  #
  # Manual configuration:
  #   make[4]: *** [scripts/Makefile.build:516: drivers/net/wireless/rockchip_wlan/rtl8852be] Error 2
  #     solution: CONFIG_WL_ROCKCHIP=n
  configfile = ./rk35xx_legacy_config;

  extraMeta.branch = "5.10";

  allowImportFromDerivation = true;
})
.overrideAttrs (old: {
  name = "k"; # dodge uboot length limits
  nativeBuildInputs = old.nativeBuildInputs ++ [ubootTools];
})
