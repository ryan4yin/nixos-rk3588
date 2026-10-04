{stdenv, lib, fetchzip, dpkg, ...}:
  let
  in stdenv.mkDerivation rec {
      pname = "linux-u-boot-orangepi5pro-vendor";
      version = "2017.09";
      src = ./.;

      nativeBuildInputs = [ ];

      buildInputs = [
        dpkg
      ];

      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall

        # Copy the directory structure directly
        set -x
        mkdir -p $out/unpack
        dpkg -x linux-u-boot-orangepi5pro-vendor_2017.09-Sb04e-P9292-H697e-V14ee-B4d1d-R448a_arm64.deb $out/unpack
        mv $out/unpack/usr/lib/linux-u-boot-vendor-orangepi5pro/u-boot.itb $out/
        mv $out/unpack/usr/lib/linux-u-boot-vendor-orangepi5pro/idbloader.img $out/
        rm -r $out/unpack
        set +x

        runHook postInstall
      '';
  }

  ## See
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/uboot/default.nix
  # https://github.com/armbian/build/blob/545b6e28bb7e00336ab108ffc362f0124e86701c/config/boards/orangepi5pro.csc
  # https://github.com/armbian/os/pkgs/container/os%2Fuboot-orangepi5pro-vendor
  # https://github.com/orangepi-xunlong/u-boot-orangepi/commits/v2017.09-rk3588/
