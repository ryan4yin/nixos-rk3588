{stdenv}: let
  # Prebuilt u-boot for rock-5a, built from armbian/build with command:
  #   ./compile.sh build BOARD=rock-5a BRANCH=legacy BUILD_DESKTOP=no BUILD_MINIMAL=yes BUILD_ONLY=u-boot KERNEL_CONFIGURE=no RELEASE=bookworm
  # And the unpack `output/debs/linux-u-boot-rock-5a-legacy_xxx.deb` to get the files below.
  idbloader_img = ./linux-u-boot-legacy-rock-5a/idbloader.img;
  u_boot_itb = ./linux-u-boot-legacy-rock-5a/u-boot.itb;
in
  stdenv.mkDerivation {
    pname = "u-boot-prebuilt";
    version = "unstable-2023-08-27";

    buildCommand = ''
      install -Dm444 ${idbloader_img} $out/idbloader.img
      install -Dm444 ${u_boot_itb} $out/u-boot.itb
    '';
  }
