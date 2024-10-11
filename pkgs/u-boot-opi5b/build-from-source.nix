{
  lib,
  fetchFromGitHub,
  pkgs,
  stdenv,
}: let
  rkbin-rk3588 = (pkgs.callPackage ../rkbin-rk3588 {});
in 
  stdenv.mkDerivation {
    pname = "u-boot";
    version = "v2023.07.02";

    src = pkgs.fetchFromGitHub {
      owner = "u-boot";
      repo = "u-boot";
      rev = "83cdab8b2c6ea0fc0860f8444d083353b47f1d5c"; # "v2023.07.02" branch
      sha256 = "sha256-HPBjm/rIkfTCyAKCFvCqoK7oNN9e9rV9l32qLmI/qz4=";
    };

    nativeBuildInputs = with pkgs; [
      (python3.withPackages (p: with p; [
        setuptools
        pyelftools
      ]))

      swig
      ncurses
      gnumake
      bison
      flex
      openssl
      bc
    ] ++ [ rkbin-rk3588 ];
    
    configurePhase = ''
      make ARCH=arm evb-rk3588_defconfig
    '';

    buildPhase = ''
      patchShebangs tools scripts
      make -j$(nproc) \
        ROCKCHIP_TPL=${rkbin-rk3588}/rk3588_ddr_lp4_2112MHz_lp5_2736MHz_v1.15.bin \
        BL31=${rkbin-rk3588}/rk3588_bl31_v1.45.elf
    '';

    installPhase = ''
      mkdir $out
      cp u-boot-rockchip.bin $out/u-boot.bin
    '';
  }

