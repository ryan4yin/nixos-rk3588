{
  fetchFromGitHub,
  buildUBoot,
  defconfig,
  ...
}: let
  rkbin = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "rkbin";
    rev = "a2a0b89b6c8c612dca5ed9ed8a68db8a07f68bc0";
    hash = "sha256-U/jeUsV7bhqMw3BljmO6SI07NCDAd/+sEp3dZnyXeeA=";
  };
in
  buildUBoot rec {
    version = "2024.01";
    src = fetchFromGitHub {
      owner = "u-boot";
      repo = "u-boot";
      rev = "v${version}";
      hash = "sha256-0Da7Czy9cpQ+D5EICc3/QSZhAdCBsmeMvBgykYhAQFw=";
    };
    inherit defconfig;
    patches = [];
    # https://github.com/armbian/build/blob/main/config/boards/rock-5a.csc
    # Configuring normal/SPI uboot target map
    extraMakeFlags = [
      "BL31=${rkbin}/bin/rk35/rk3588_bl31_v1.45.elf rock-5a-spi-rk3588s_defconfig spl/u-boot-spl.bin u-boot.dtb u-boot.itb;;rkspi_loader.img"
      "BL31=${rkbin}/bin/rk35/rk3588_bl31_v1.45.elf rock-5a-rk3588s_defconfig spl/u-boot-spl.bin u-boot.dtb u-boot.itb;;idbloader.img u-boot.itb"
    ];
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = [
      "spl/u-boot-spl.bin"

      "u-boot.itb"
      "idbloader.img"
    ];
  }
