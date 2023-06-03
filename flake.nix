{
  description = "A minimal NixOS configuration for the Orange Pi 5 SBC";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05-small";

    # GPU drivers
    mesa-panfork = {
      url = "gitlab:panfork/mesa/csf";
      flake = false;
    };

    linux-rockchip = {
      url = "github:armbian/linux-rockchip/rk-5.10-rkr4";
      flake = false;
    };
  };

  outputs = inputs@{nixpkgs, ...}: {
    nixosConfigurations = {
      # Orange Pi 5 SBC
      orangepi5 = import "${nixpkgs}/nixos/lib/eval-config.nix" rec {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules =
          [
            {
              networking.hostName = "orangepi5";
            }

            ./orangepi5.nix
          ];
      };
    };
  };
}
