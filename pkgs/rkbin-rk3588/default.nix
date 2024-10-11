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
    rev = "12657ed7c65f16f89e6bd5ea82ca670d3324fc70";
    sha256 = "sha256-Lyo4LHg8HfeJTQ0Y29d0ITdF1JDOFOmgK2JxvBlKL1E=";
  };

  installPhase = ''
    mkdir $out && cp rk35/rk3588* $out/
  '';
}
