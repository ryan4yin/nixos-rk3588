{
  lib,
  pkgs,
  mesa-panfork,
  ...
}: {
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
    initrd.availableKernelModules = lib.mkForce ["dm_mod" "dm_crypt" "encrypted_keys"];
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
            galliumDrivers = ["panfrost" "swrast"];
            vulkanDrivers = ["swrast"];
          })
          .overrideAttrs (_: {
            pname = "mesa-panfork";
            version = "23.0.0-panfork";
            src = mesa-panfork;
          })
        )
        .drivers;
    };

    enableRedistributableFirmware = lib.mkForce true;
    firmware = [
      # firmware for Mali-G610 GPU
      (pkgs.callPackage ../../pkgs/mali-firmware {})
    ];
  };
}
