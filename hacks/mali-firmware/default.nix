{
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation {
  pname = "mali-g610-firmware";
  version = "unstable-2022-11-21";

  src = fetchurl {
    url = "https://github.com/JeffyCN/rockchip_mirrors/raw/309268f7a34ca0bba0ab94a0b09feb0191c77fb8/firmware/g610/mali_csffw.bin";
    hash = "sha256-rZFRGnf6EQr0aiopytniJVJNnPqf41vc6WYG01TmB94=";
  };

  buildCommand = ''
    install -Dm444 $src $out/lib/firmware/mali_csffw.bin
  '';
}
