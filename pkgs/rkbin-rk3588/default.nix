{
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "rkbin-rk3588";
  version = "0.0.1";

  # https://github.com/armbian/rkbin/tree/master
  src = fetchFromGitHub {
    owner = "armbian";
    repo = "rkbin";
    rev = "ff684f607af661ac0ef5ce59f0533adb2beb6e12";
    sha256 = "sha256-sOhdlvdQrH7eykPV2y2r7/NqNcxdgtnBshQAka6ZXD0=";
  };

  installPhase = ''
    mkdir $out && cp rk35/rk3588* $out/
  '';
}
