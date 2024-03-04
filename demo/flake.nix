{
  description = "NixOS configuration for rk3588 remote deployment";

  inputs = {
    nixos-rk3588.url = "path:..";
  };

  outputs = {nixos-rk3588, ...}: let
    # using the same nixpkgs as nixos-rk3588 to utilize the cross-compilation cache.
    inherit (nixos-rk3588.inputs) nixpkgs;
    boardModule = nixos-rk3588.nixosModules.orangepi5;

    # 1. for cross-compilation on x86_64-linux
    system = "x86_64-linux";
    # Compile the kernel using a cross-compilation tool chain
    # Which is faster than emulating the target system.
    pkgsKernel = import nixpkgs {
      localSystem = "x86_64-linux";
      crossSystem = "aarch64-linux";
    };
    # 2. for native compilation on aarch64-linux SBCs.
    # system = "aarch64-linux";
    # native compilation tool chain for the linux kernel
    # pkgsKernel = nixpkgs;
  in {
    colmena = {
      meta = {
        nixpkgs = import nixpkgs {inherit system;};
        rk3588 = {
          inherit nixpkgs pkgsKernel;
        };
      };

      opi5 = {
        deployment.targetHost = "192.168.5.42";
        deployment.targetUser = "root";
        # Allow local deployment with `colmena apply-local`
        # deployment.allowLocalDeployment = true;

        imports = [
          # import the rk3588 module, which contains the configuration for bootloader/kernel/firmware
          boardModule.core
          boardModule.sd-image

          # your custom configuration
          ./configuration.nix
          ./user-group.nix
        ];
      };
    };
  };
}
