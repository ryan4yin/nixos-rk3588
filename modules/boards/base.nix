{ lib
, pkgs
, rk3588
, ...
}:


let
  inherit (rk3588) mesa-panfork;
in
{
  # =========================================================================
  #      Base NixOS Configuration
  # =========================================================================

  boot = {
    # Some filesystems (e.g. zfs) have some trouble with cross (or with BSP kernels?) here.
    supportedFilesystems = lib.mkForce [
      "vfat"
      "fat32"
      "exfat"
      "ext4"
      "btrfs"
    ];

    loader = {
      grub.enable = lib.mkForce false;
      generic-extlinux-compatible.enable = lib.mkForce true;
    };

    initrd.includeDefaultModules = lib.mkForce false;
    initrd.availableKernelModules = lib.mkForce [ "dm_mod" "dm_crypt" "encrypted_keys" ];
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  hardware = {
    # driver & firmware for Mali-G610 GPU
    # it works on all rk2588/rk3588s based SBCs.
    opengl = {
      enable = lib.mkDefault true;
      package =
        lib.mkForce
          (
            (pkgs.mesa.override {
              galliumDrivers = [ "panfrost" "swrast" ];
              vulkanDrivers = [ "swrast" ];
            }).overrideAttrs (_: {
              pname = "mesa-panfork";
              version = "23.0.0-panfork";
              src = mesa-panfork;
            })
          ).drivers;
    };

    enableRedistributableFirmware = lib.mkForce true;
    firmware = [
      # firmware for Mali-G610 GPU
      (pkgs.callPackage ../../pkgs/mali-firmware { })
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = lib.mkDefault "23.05"; # Did you read the comment?
}
