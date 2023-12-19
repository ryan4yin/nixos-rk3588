# TODO not working yet!
{
  lib,
  buildUBoot,
  fetchFromGitHub,
  rkbin-rk3588,
}:
(buildUBoot rec {
  version = "2023.08.27";

  # https://github.com/radxa/u-boot/tree/stable-5.10-rock5
  src = fetchFromGitHub {
    owner = "radxa";
    repo = "u-boot";
    rev = "8b4ecf0859a188a9de2017db7d5fccc90928318e"; # branch - stable-5.10-rock5
    sha256 = "sha256-29aulIto9YQmfnMwTqP8d70y2r/b4JgblKoByV4397o=";
  };

  # https://github.com/radxa/u-boot/blob/stable-5.10-rock5/configs/rock-5a-rk3588s_defconfig
  defconfig = "rock-5a-rk3588s_defconfig";

  extraMeta.platforms = ["aarch64-linux"];
  BL31 = "${rkbin-rk3588}/rk3588_bl31_v1.38.elf";

  buildPhase = ''
    make -j20 CROSS_COMPILE=aarch64-unknown-linux-gnu- \
      BL31=${rkbin-rk3588}/rk3588_bl31_v1.38.elf \
      spl/u-boot-spl.bin u-boot.dtb u-boot.itb

    tools/mkimage -n rk3588 -T rksd -d \
      ${rkbin-rk3588}/rk3588_ddr_lp4_2112MHz_lp5_2736MHz_v1.11.bin:spl/u-boot-spl.bin \
      idbloader.img
  '';

  filesToInstall = [
    "spl/u-boot-spl.bin"

    "u-boot.itb"
    "idbloader.img"
  ];
})
.overrideAttrs (oldAttrs: {
  patches = []; # remove all patches, which is not compatible with thead-u-boot
})
