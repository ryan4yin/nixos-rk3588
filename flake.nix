{
  description = "A minimal NixOS configuration for the RK3588/RK3588S based SBCs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05-small";
    flake-utils.url = "github:numtide/flake-utils";

    # GPU drivers
    mesa-panfork = {
      url = "gitlab:panfork/mesa/csf";
      flake = false;
    };

    # For CI checks
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "";
      };
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, pre-commit-hooks, ... }:
    {
      nixosModules = {
        # Orange Pi 5 SBC
        orangepi5 = import ./modules/boards/orangepi5.nix;
        # Orange Pi 5 Plus SBC
        # TODO not complete yet
        orangepi5plus = import ./modules/boards/orangepi5plus.nix;
        # Rock 5 Model A SBC
        # TODO not complete yet
        rock5a = import ./modules/boards/rock5a.nix;
      };

      nixosConfigurations = builtins.mapAttrs
        (name: module:
          import "${nixpkgs}/nixos/lib/eval-config.nix" {
            system = "x86_64-linux";
            specialArgs = inputs;
            modules =
              [
                {
                  networking.hostName = name;

                  nixpkgs.crossSystem = {
                    config = "aarch64-unknown-linux-gnu";
                  };
                }

                module
                ./modules/configuration.nix
              ];
          })
        self.nixosModules;
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgsKernel = import nixpkgs {
          inherit system;

          crossSystem.config = "aarch64-unknown-linux-gnu";

          overlays = [
            (_self: super: {
              linuxPackages_rockchip = super.linuxPackagesFor (super.callPackage ./pkgs/kernel/legacy.nix { });
            })
          ];
        };
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          # sdImage
          sdImage-opi5 = self.nixosConfigurations.orangepi5.config.system.build.sdImage;
          sdImage-opi5plus = self.nixosConfigurations.orangepi5plus.config.system.build.sdImage;
          sdImage-rock5a = self.nixosConfigurations.rock5a.config.system.build.sdImage;

          # the custom kernel for debugging
          # use `nix develop` to enter the environment with the custom kernel build environment available.
          # and then use `unpackPhase` to unpack the kernel source code and cd into it.
          # then you can use `make menuconfig` to configure the kernel.
          #
          # problem
          #   - using `make menuconfig` - Unable to find the ncurses package.
          # Solution
          #   - unpackPhase, and the use `nix develop .#fhsEnv` to enter the fhs test environment.
          #   - Then use `make menuconfig` to configure the kernel.
          kernel = pkgsKernel.linuxPackages_rockchip.kernel.dev;
        };

        # use `nix develop .#fhsEnv` to enter the fhs test environment defined here.
        # for kernel debugging
        #
        # the code here is mainly copied from:
        #   https://nixos.wiki/wiki/Linux_kernel#Embedded_Linux_Cross-compile_xconfig_and_menuconfig
        devShells.fhsEnv =
          (pkgs.buildFHSUserEnv {
            name = "kernel-build-env";
            targetPkgs = pkgs_: (with pkgs_;
              [
                # we need theses packages to make `make menuconfig` work.
                pkgconfig
                ncurses

                # custom kernel
                pkgsKernel.linuxPackages_rockchip.kernel

                # arm64 cross-compilation toolchain
                pkgsKernel.gccStdenv.cc
                # native gcc
                gcc
              ]
              ++ pkgs.linux.nativeBuildInputs);
            runScript = pkgs.writeScript "init.sh" ''
              # set the cross-compilation environment variables.
              export CROSS_COMPILE=aarch64-unknown-linux-gnu-
              export ARCH=arm64
              export PKG_CONFIG_PATH="${pkgs.ncurses.dev}/lib/pkgconfig:"
              exec bash
            '';
          }).env;

        devShells.default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };

        checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            # nix
            deadnix.enable = true;
            nixpkgs-fmt.enable = true;
            statix.enable = true;
          };
        };
      });
}
