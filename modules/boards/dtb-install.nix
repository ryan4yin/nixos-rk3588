{
  config,
  lib,
  options,
  pkgs,
  modulesPath,
  nixos-generators,
  ...
}: let
  extraInstallCommands = ''
    ${pkgs.coreutils}/bin/mkdir -p /boot/dtb/base
    ${pkgs.coreutils}/bin/cp -r ${config.hardware.deviceTree.package}/rockchip/* /boot/dtb/base/
    ${pkgs.coreutils}/bin/sync
  '';
in {
  # Note that this is only needed on UEFI systems, even though we set it
  # everywhere. It will have no effect unless `boot.loader.grub.enable = true`.
  boot.loader = {
    systemd-boot.extraInstallCommands = extraInstallCommands;
    grub.extraInstallCommands = extraInstallCommands;
  };
}
