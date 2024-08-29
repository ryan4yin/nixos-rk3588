{stdenv}: let
  # Prebuilt u-boot for orangepi-5b with smmc-enable.patch provided from:
  #   https://github.com/fb87/nixos-orangepi-5x
  u_boot_bin = ./linux-u-boot-legacy-orangepi-5b/u-boot.bin;
in
  stdenv.mkDerivation {
    pname = "u-boot-prebuilt";
    version = "unstable-2023-07-02";

    buildCommand = ''
      install -Dm444 ${u_boot_bin} $out/u-boot.bin
    '';
  }
