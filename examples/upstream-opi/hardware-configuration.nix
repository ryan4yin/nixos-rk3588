{lib, pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = {
      # Disabled zfs because it limits the range of kernel versions it's
      # compatible with, and makes kernel packages marked as "broken" every now
      # and then (since zfs source has moved out of kernel tree). If you want
      # zfs, change this and try different kernel packages above until build
      # succeeds.
      zfs = lib.mkForce false;
    };

    kernelParams = lib.mkBefore [
      "rootwait"

      "earlycon" # enable early console, so we can see the boot messages via serial port / HDMI
      "consoleblank=0" # disable console blanking(screen saver)
      "console=ttyS2,1500000" # serial port
      "console=tty1" # HDMI
    ];
  };

  # We do not set fileSystems mounts because our root and firmware partitions
  # are mounted by SD card configuration in ./sdcard.nix. If you add more
  # partitions, set them up here.
}
