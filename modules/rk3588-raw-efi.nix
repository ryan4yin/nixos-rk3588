{
  config,
  lib,
  options,
  pkgs,
  modulesPath,
  nixos-generators,
  ...
}: let
  # Import raw-efi from nixos-generators
  raw-efi = nixos-generators.nixosModules.raw-efi;

  extraInstallCommands = ''
    mkdir -p /boot/dtb/base
    cp -r ${config.boot.kernelPackages.kernel}/dtbs/rockchip/* /boot/dtb/base/
    sync
  '';
in {
  # Reuse and extend the raw-efi format
  imports = [raw-efi];

  boot.loader = {
    systemd-boot.extraInstallCommands = extraInstallCommands;
    grub.extraInstallCommands = extraInstallCommands;
  };
}
