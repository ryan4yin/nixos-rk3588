{ fetchFromGitHub, stdenvNoCC, ... }: stdenvNoCC.mkDerivation {
    pname = "orangepi-firmware";
    version = "2024.01.24";
    dontBuild = true;
    dontFixup = true;
    compressFirmware = false;

    src = fetchFromGitHub {
        owner = "orangepi-xunlong";
        repo = "firmware";
        rev = "76ead17a1770459560042a9a7c43fe615bbce5e7";
        hash = "sha256-mltaup92LTGbuCXeGTMdoFloX3vZRbaUFVbh6lwveFs=";
    };

    installPhase = ''
        runHook preInstall

        mkdir -p $out/lib/firmware
        cp -a * $out/lib/firmware/

        runHook postInstall
    '';
}
