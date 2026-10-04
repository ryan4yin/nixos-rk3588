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
in {
  # Reuse and extend the raw-efi format
  imports = [raw-efi];
}
