{
  lib,
  pkgs,
  ...
}: {
  # =========================================================================
  #      Base NixOS Configuration
  # =========================================================================

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  boot = {
    supportedFilesystems = lib.mkForce [
      "vfat"
      "fat32"
      "exfat"
      "ext4"
      "btrfs"
    ];

    initrd.includeDefaultModules = lib.mkForce false;
    initrd.availableKernelModules = lib.mkForce ["dm_mod" "dm_crypt" "encrypted_keys" "uas"];
  };

  hardware = {
    # driver & firmware for Mali-G610 GPU
    # it works on all rk2588/rk3588s based SBCs.
    opengl.package =
      (
        (pkgs.mesa.override {
          galliumDrivers = ["panfrost" "swrast"];
          vulkanDrivers = ["swrast"];
        })
        .overrideAttrs (_: {
          pname = "mesa-panfork";
          version = "23.0.0-panfork";
          src = pkgs.fetchFromGitLab {
            owner = "panfork";
            repo = "mesa";
            rev = "120202c675749c5ef81ae4c8cdc30019b4de08f4"; # branch: csf
            hash = "sha256-4eZHMiYS+sRDHNBtLZTA8ELZnLns7yT3USU5YQswxQ0=";
          };
        })
      )
      .drivers;

    enableRedistributableFirmware = lib.mkForce true;
    firmware = [
      # firmware for Mali-G610 GPU
      (pkgs.callPackage ../../pkgs/mali-firmware {})
    ];
  };
}
