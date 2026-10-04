{nixpkgs, lib, config, pkgs, ...}:
let
  # Feel free to change the UUID, maybe even generate one randomly. We use
  # hardcoded UUID so that the kernel may always find the root partition, no
  # matter if it's on SD card, NVMe or USB stick.
  #
  # Hardcoded UUID may be a problem if connect to your board something with a
  # partition that already uses this UUID.
  rootPartitionUUID = "14e19a7b-0ae0-484d-9d54-43bd6fdc20c7";
  # TODO: change this if you are using a different board:
  uboot = pkgs.ubootOrangePi5Plus;
in {
  imports = [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
  ];

  boot = {
    kernelParams = [
      "root=UUID=${rootPartitionUUID}"
      "rootfstype=ext4"
    ];
    consoleLogLevel = 7;

    loader = {
      grub.enable = lib.mkForce false;
      generic-extlinux-compatible.enable = lib.mkForce true;
    };
  };

  # The image we're making looks like this:
  #
  #   sd-card.img
  #   ├ 32MB gap: contains u-boot code at the rights offsets where board expects it
  #   ├ 1MB RPi-specific "firmware" partition, unused in our case
  #   │ (but nevertheless mounts to /boot/firmware)
  #   └ root partition with all our data (including /var and /home),
  #     among other things contains:
  #      ├ /boot/extlinux: config u-boot reads to find our kernel
  #      └ /boot/nixos: all installed kernels, referenced by extlinux
  #
  # If you want more partitions, e.g. swap, /var, /home, customize this block.
  sdImage = {
    inherit rootPartitionUUID;
    compressImage = true;

    # The "firmware" partition is mounted to /boot/firmware/ and used for
    # raspberrypi-specific binary blobs, we don't need it. Our u-boot data will
    # live in the root partition under /boot — this is the default on Nixpkgs.
    populateFirmwareCommands = "";

    # The sd-image.nix has no way to disable firmware partition, so let's just
    # set its size to 1MB. We won't use it.
    firmwareSize = 1; # MiB
    firmwarePartitionName = "DUMMY_UNUSED";

    # Gap in front of the /boot/firmware partition, in mebibytes (1024×1024
    # bytes). That space is needed to fit the idbloader.img and u-boot.itb (see below).
    # The 32MB is extremely generous, the actual binaries below are much smaller.
    firmwarePartitionOffset = 32;

    # This installs the extlinux.conf into /boot, so u-boot finds it and
    # discovers our kernel.
    populateRootCommands = ''
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';

    # Write u-boot code into the 32MB gap
    postBuildCommands = ''
      dd if=${uboot}/idbloader.img of=$img seek=64 conv=fsync,notrunc
      dd if=${uboot}/u-boot.itb of=$img seek=16384 conv=fsync,notrunc
    '';
  };
}
