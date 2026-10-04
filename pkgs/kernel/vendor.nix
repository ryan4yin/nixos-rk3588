# args of buildLinux:
#   https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/kernel/generic.nix
# Note that this method will use the deconfig in source tree,
# commbined the common configuration defined in pkgs/os-specific/linux/kernel/common-config.nix, which is suitable for a NixOS system.
# but it't not suitable for embedded systems, so we comment it out.
# ================================================================
# If you already have a generated configuration file, you can build a kernel that uses it with pkgs.linuxManualConfig
# The difference between deconfig and the generated configuration file is that the generated configuration file is more complete,
#
{ fetchFromGitHub
, linuxManualConfig
, ubootTools
, fetchurl
, ...
}:
let
  modDirVersion = "6.1.115";
in
(linuxManualConfig {
  inherit modDirVersion;
  version = "${modDirVersion}-armbian";
  extraMeta.branch = "rk-6.1-rkr5.1";

  # https://github.com/Joshua-Riek/linux-rockchip/tree/noble
  src = fetchFromGitHub {
    owner = "armbian";
    repo = "linux-rockchip";
    #rev = "rk-6.1-rkr5.1";
    rev = "b908c7339f51eddcfe8402cd15d1e1f8f4e67c29";
    hash = "sha256-70wGP16SJHs7I8HklhNdrJbWzfvcgJCupgfOq81e1U8=";
  };

  kernelPatches = [
  ];

  # Steps to the generated kernel config file
  #  1. git clone --depth 1 https://github.com/hbiyik/linux.git -b rk-6.1-rkr3-panthor
  #  2. put https://github.com/hbiyik/linux/blob/rk-6.1-rkr3-panthor/debian.rockchip/config/config.common.ubuntu to arch/arm64/configs/rk35xx_vendor_defconfig
  #  3. run `nix develop .#fhsEnv` in this project to enter the fhs test environment defined here.
  #  4. `make rk35xx_vendor_defconfig` in the kernel root directory to configure the kernel.
  #  5. Then use `make menuconfig` in kernel's root directory to view and customize the kernel(like enable/disable rknpu, rkflash, ACPI(for UEFI) etc).
  #  6. copy the generated .config to ./pkgs/kernel/rk35xx_vendor_config (also be sure to update the corresponding `.nix` file accordingly) and commit it.
  # 
  configfile = ./rk35xx_vendor_config;
  config = import ./rk35xx_vendor_config.nix;
}).overrideAttrs (old: {
  name = "k"; # dodge uboot length limits
  nativeBuildInputs = old.nativeBuildInputs ++ [ ubootTools ];

  # The hacky mali code tries to include a binary blob by a relative path,
  # which works only when your src dir is the same as build dir. It breaks with
  # Nix'es reproducible builds where these are cleanly separated. We patch the
  # path to point be absolute. Not sure if this is a clean solution, but it
  # seems to work.
  postPatch =
    ''
      sed -i "drivers/gpu/arm/bifrost/csf/mali_kbase_csf_firmware.c" \
        -e "s:drivers/gpu/arm/bifrost/mali_csffw.bin:$src/drivers/gpu/arm/bifrost/mali_csffw.bin:"
    ''
    + "\n"
    + old.postPatch;
})
