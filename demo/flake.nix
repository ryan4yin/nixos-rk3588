{
  description = "NixOS configuration for rk3588 remote deployment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05-small";
    nixos-rk3588.url = "github:ryan4yin/nixos-rk3588";
  };

  outputs = { self, nixpkgs, nixos-rk3588 }: let
    system = "aarch64-linux";
  in {
    colmena = {
      meta = {
        nixpkgs = import nixpkgs { inherit system; };
        specialArgs = {
          inherit nixpkgs;
          pkgsKernel = nixos-rk3588.packages.${system}.pkgsKernelCross;
        };
      };

      lp4a = { name, nodes, ... }: {
        deployment.targetHost = "192.168.5.42";
        deployment.targetUser = "root";
        # Allow local deployment with `colmena apply-local`
        deployment.allowLocalDeployment = true;

        imports = [
          # import the rk3588 module, which contains the configuration for bootloader/kernel/firmware
          (nixos-rk3588 + "/modules/boards/orangepi5.nix")

          # your custom configuration
          ./configuration.nix
          ./user-group.nix
        ];
      };
    };
  };
}
