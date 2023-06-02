{
  description = "A minimal NixOS configuration for the Orange Pi 5 SBC";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    # TODO add GPU drivers
    # mesa-panfork = {
    #   url = "gitlab:panfork/mesa/csf";
    #   flake = false;
    # };

    linux-rockchip = {
      url = "github:armbian/linux-rockchip/rk-5.10-rkr4";
      flake = false;
    };
  };

  outputs = inputs@{nixpkgs, ...}: {
      nixosConfigurations = {
        # Orange Pi 5 SBC
        opi5 = import "${nixpkgs}/nixos/lib/eval-config.nix" {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules =
            [
              {
                networking.hostName = "opi5";
              }

              ./boot.nix
            ];
        };
      };
    };
}
