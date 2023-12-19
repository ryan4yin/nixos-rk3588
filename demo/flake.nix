{
  description = "NixOS configuration for rk3588 remote deployment";

  inputs = {
    nixos-rk3588.url = "path:..";
  };

  outputs = {nixos-rk3588, ...}: let
    system = "x86_64-linux"; # for cross-compilation on x86_64-linux
    # system = "aarch64-linux";  # for native compilation on aarch64-linux
  in {
    colmena = {
      meta = {
        # using the same nixpkgs as nixos-rk3588 to utilize the cross-compilation cache.
        nixpkgs = import nixos-rk3588.inputs.nixpkgs {inherit system;};
        specialArgs = {
          inherit (nixos-rk3588.inputs) nixpkgs;

          # Provide rk3588 inputs as special argument
          rk3588 = nixos-rk3588.inputs;
        };
      };

      opi5 = {
        deployment.targetHost = "192.168.5.42";
        deployment.targetUser = "root";
        # Allow local deployment with `colmena apply-local`
        # deployment.allowLocalDeployment = true;

        # Use the crossSystem configuration for cross-compilation
        # Remove this module if you want to compile natively on aarch64-linux!
        nixpkgs.crossSystem.config = "aarch64-unknown-linux-gnu";

        imports = [
          # import the rk3588 module, which contains the configuration for bootloader/kernel/firmware
          nixos-rk3588.nixosModules.orangepi5

          # your custom configuration
          ./configuration.nix
          ./user-group.nix
        ];
      };
    };
  };
}
