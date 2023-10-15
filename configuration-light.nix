# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{

  # ENV VARS
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    TERM = "foot";
    TERMINAL = "foot";
    BROWSER = "firefox";
    VISUAL = "nvim";
  };

  # NeoVim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = ''
        set number
        set tabstop=2
        set shiftwidth=2
      '';
    };
  };

  # Hyprland
  programs.hyprland.enable = true;

  # fish shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment.shells = with pkgs; [ fish ];

  # Bootloader stuff
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking and set hostname
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    wireless.enable = false;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Fonts
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    dina-font
    proggyfonts
    font-awesome
    meslo-lgs-nf
    ubuntu_font_family
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  # Greeter
  # Run GreetD on TTY2
  services.greetd = {
    enable = true;
    vt = 7;
    settings = {
      default_session = {
        command = "${
            lib.makeBinPath [ pkgs.greetd.tuigreet ]
          }/tuigreet --user-menu --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # XDG stuff
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable gvfs (mount, trash...) for thunar
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    minizip
    git
    foot
    gnome3.adwaita-icon-theme
    waybar
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    grim
    slurp
    pipewire
    wireplumber
    pavucontrol
    xfce.thunar
    hyprpaper
    gnome.gnome-themes-extra
    imv
    rofi-wayland
    ranger
    neofetch
    mpv
    mako
    wl-clipboard
    brightnessctl
    killall
    playerctl
    #mpc-cli
    unzip
    #ffmpeg
    xarchiver
    #obs-studio
    #python3
    polkit
    polkit-kde-agent
    #chromium
		superTuxKart
  ];

  system.stateVersion = "23.05"; # Did you read the comment?

}

