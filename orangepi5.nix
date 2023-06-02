{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: 

{

# =========================================================================
#      Orange Pi 5 Specific Configuration
# =========================================================================


  boot = {
    kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./hacks/kernel {
        src = inputs.linux-rockchip;
      });

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    initrd.includeDefaultModules = false;
  };

  hardware = {
    deviceTree = {
      name = "rockchip/rk3588s-orangepi-5.dtb";
      overlays = [
        {
          name = "orangepi5-sata-overlay";
          dtsText = ''
            // Orange Pi 5 Pcie M.2 to sata
            /dts-v1/;
            /plugin/;

            / {
              compatible = "rockchip,rk3588s-orangepi-5";

              fragment@0 {
                target = <&sata0>;

                __overlay__ {
                  status = "okay";
                };
              };

              fragment@1 {
                target = <&pcie2x1l2>;

                __overlay__ {
                  status = "disabled";
                };
              };
            };
          '';
        }
        {
          name = "orangepi5-i2c-overlay";
          dtsText = ''
            /dts-v1/;
            /plugin/;

            / {
              compatible = "rockchip,rk3588s-orangepi-5";

              fragment@0 {
                target = <&i2c1>;

                __overlay__ {
                  status = "okay";
                  pinctrl-names = "default";
                  pinctrl-0 = <&i2c1m2_xfer>;
                };
              };
            };
          '';
        }
      ];
    };

    opengl = {
      enable = true;
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
            src = inputs.mesa-panfork;
          })
        )
        .drivers;
    };

    firmware = [
      (pkgs.callPackage ./hacks/mali-firmware {})
    ];
  };

  # Some filesystems (e.g. zfs) have some trouble with cross (or with BSP kernels?) here.
  boot.supportedFilesystems = lib.mkForce [
    "vfat"
    "fat32"
    "exfat"
    "ext4"
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  nixpkgs.overlays = [
    (_: super: {makeModulesClosure = x: super.makeModulesClosure (x // {allowMissing = true;});})
  ];


  networking = {
    useDHCP = false;
    wireless.iwd = {
      enable = true;
      settings.General.Country = "CN";
    };
  };

  systemd.network = {
    enable = true;
    wait-online.anyInterface = true;

    networks = {
      wired = {
        name = "end1";
        DHCP = "yes";
        domains = ["home"];
      };

      wireless = {
        name = "wlan0";
        DHCP = "yes";
        domains = ["home"];
      };
    };
  };

  hardware.enableRedistributableFirmware = true;
  powerManagement.cpuFreqGovernor = "ondemand";

  # build an SD image, by the command:
  #   nix build .#
  system.build.sdImage = import "${inputs.nixpkgs}/nixos/lib/make-disk-image.nix" {
    name = "orangepi5-sd-image";
    copyChannel = false;
    inherit config lib pkgs;
  };

# =========================================================================
#      Common NixOS Configuration
# =========================================================================

  # enable flakes globally
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git      # used by nix flakes
    wget
    curl
    aria2
    neofetch
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";         # disable root login
      PasswordAuthentication = false; # disable password login
    };
    openFirewall = true;
  };

  virtualisation.docker = {
    enable = true;
  };

  users.groups = {
    ryan = {};
    docker = {};
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.orangepi = {
    # To generate a hashed password run `mkpasswd`.
    # this is the hash of the password "orangepi"
    hashedPassword = "$y$j9T$XdXelnTiFpSYTctcJktMq1$5PWX1enq.UAUM0v9kcdy1oDe/uq8t05doDoqaErt3w/";
    isNormalUser = true;
    home = "/home/orangepi";
    description = "orangepi";
    extraGroups = [ "users" "networkmanager" "wheel" "docker"];
    openssh.authorizedKeys.keys = [
        # TODO replace this with your own public key!
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL7hMSL3g0AGEofxFHWHAcg5FQT/YPkB7T+f2vuVVe91 ryan@gluttony"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
