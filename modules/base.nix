{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: 


let
  username = "ryan";
  # To generate a hashed password run `mkpasswd`.
  # this is the hash of the password "rk3588"
  hashedPassword = "$y$j9T$V7M5HzQFBIdfNzVltUxFj/$THE5w.7V7rocWFm06Oh8eFkAKkUFb5u6HVZvXyjekK6";
  # TODO replace this with your own public key!
  publickey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK3F3AH/vKnA2vxl72h67fcxhIK8l+7F/bdE1zmtwTVU ryan@romantic";
in
{
  # =========================================================================
  #      Users & Groups NixOS Configuration
  # =========================================================================

  # TODO Define a user account. Don't forget to update this!
  users.users."${username}" = {
    inherit hashedPassword;
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [ "users" "networkmanager" "wheel" "docker"];
    openssh.authorizedKeys.keys = [
      publickey
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    publickey
  ];

  users.groups = {
    "${username}" = {};
    docker = {};
  };

  # =========================================================================
  #      Networking Configuration
  # =========================================================================

  networking = {
    networkmanager.enable = true;
    wireless.enable = false;
    # defaultGateway = "192.168.5.201";
    # nameservers = [
    #   "119.29.29.29" # DNSPod
    #   "223.5.5.5" # AliDNS
    # ];

    # interfaces.enp5s0 = {
    #   useDHCP = false;
    #   ipv4.addresses = [
    #     {
    #       address = "192.168.5.103";
    #       prefixLength = 24;
    #     }
    #   ];
    # };
  };

  # =========================================================================
  #      Common NixOS Configuration
  # =========================================================================

  nix.settings = {
    # Manual optimise storage: nix-store --optimise
    # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
    auto-optimise-store = true;
    builders-use-substitutes = true;
    # enable flakes globally
    experimental-features = ["nix-command" "flakes"];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  # make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
  nix.nixPath = ["/etc/nix/inputs"];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # editor
    git # used by nix flakes
    wget
    curl
    aria2

    # system
    neofetch
    lm_sensors # `sensors`
    ranger # terminal file manager
    btop # replacement of htop/nmon
    iotop
    iftop

    # system call monitoring
    strace
    lsof

    mtr # A network diagnostic tool
    iperf3 # A tool for measuring TCP and UDP bandwidth performance
    nmap # A utility for network discovery and security auditing
    ldns # replacement of dig, it provide the command `drill`
    socat # replacement of openbsd-netcat
    tcpdump # A powerful command-line packet analyzer

    # archives
    zip
    xz
    unzip
    p7zip
    zstd
    file
    which
    tree
    gnused
    gnutar
    gawk

    # misc
    docker-compose
    tmux

    # python, some times I may need to use python with root permission.
    (python310.withPackages (
      ps:
        with ps; [
          ipython
          requests
          pyquery
          pyyaml

          numpy
          opencv4
        ]
    ))
  ];

  # replace default editor with neovim
  environment.variables.EDITOR = "nvim";

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false; # disable password login
    };
    openFirewall = true;
  };

  virtualisation.docker = {
    enable = true;
    # start dockerd on boot.
    # This is required for containers which are created with the `--restart=always` flag to work.
    enableOnBoot = true;
  };

  boot = {
    kernelParams = [
      "console=ttyS0,115200"
    ];

    # Some filesystems (e.g. zfs) have some trouble with cross (or with BSP kernels?) here.
    supportedFilesystems = lib.mkForce [
      "vfat"
      "fat32"
      "exfat"
      "ext4"
      "btrfs"
    ];

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    initrd.includeDefaultModules = false;
  };


  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  hardware = {
    # driver & firmware for Mali-G610 GPU
    # it works on all rk2588/rk3588s based SBCs.
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

    enableRedistributableFirmware = true;
    firmware = [
      # firmware for Mali-G610 GPU
      (pkgs.callPackage ../pkgs/mali-firmware {})
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
