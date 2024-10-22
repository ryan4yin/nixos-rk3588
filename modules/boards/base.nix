{ lib
, ...
}: {
  config = {
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

      # Some default kernel modules are not available in our kernel,
      # so we have not to include them in the initrd.
      # All the default modules are listed here:
      #   https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/system/boot/kernel.nix#L257
      #
      # How I found this out:
      #   ```
      #   $ grep -r 'includeDefaultModules' ./nixpkgs/
      #   /etc/nix/inputs/nixpkgs/nixos/modules/system/boot/kernel.nix:    boot.initrd.includeDefaultModules = mkOption {
      #   /etc/nix/inputs/nixpkgs/nixos/modules/system/boot/kernel.nix:          optionals config.boot.initrd.includeDefaultModules ([
      #   /etc/nix/inputs/nixpkgs/nixos/modules/system/boot/kernel.nix:          optionals config.boot.initrd.includeDefaultModules [
      #   ````
      initrd.includeDefaultModules = lib.mkForce false;
      # Instead, we include only the modules we need for booting.
      # NOTE: this is just the modules for booting, not the modules for the system!
      # So you don't need to worry about missing modules for your hardware.
      #
      # To find out which modules you may need:
      #   ```
      #    $ grep -r 'availableKernelModules' ./nixpkgs/
      #   ```
      initrd.availableKernelModules = lib.mkForce [
        # NVMe
        "nvme"

        # SD cards and internal eMMC drives.
        "mmc_block"

        # Support USB keyboards, in case the boot fails and we only have
        # a USB keyboard, or for LUKS passphrase prompt.
        "hid"

        # For LUKS encrypted root partition.
        # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/system/boot/luksroot.nix#L985
        "dm_mod" # for LVM & LUKS
        "dm_crypt" # for LUKS
        "input_leds"
      ];
    };

    hardware = {
      enableRedistributableFirmware = lib.mkForce true;
    };
  };
}
