{
  description = "A minimal NixOS configuration for the RK3588/RK3588S based SBCs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
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

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , nixos-generators
    , pre-commit-hooks
    , ...
    }:
    let
      # Local system's architecture, the host you are running this flake on.
      localSystem = "x86_64-linux";
      pkgsLocal = import nixpkgs { system = localSystem; };
      # The native system of the target SBC.
      aarch64System = "aarch64-linux";
      pkgsNative = import nixpkgs { system = aarch64System; };

      # Cross-compilation toolchain for building on the local system.
      pkgsCross = import nixpkgs {
        inherit localSystem;
        crossSystem = aarch64System;
      };
    in
    {
      nixosModules = {

        orangepi5plus = throw "'nixosModules.orangepi5plus' has been renamed to 'nixosModules.boards.orangepi5plus'";
        orangepi5b = throw "'nixosModules.orangepi5b' has been renamed to 'nixosModules.boards.orangepi5b'";
        orangepi5 = throw "'nixosModules.orangepi5' has been renamed to 'nixosModules.boards.orangepi5'";
        rock5a = throw "'nixosModules.rock5a' has been renamed to 'nixosModules.boards.rock5a'";

        boards = {
          # Orange Pi 5 SBC
          orangepi5 = {
            core = import ./modules/boards/orangepi5.nix;
            sd-image = ./modules/sd-image/orangepi5.nix;
          };
          # Orange Pi 5b SBC
          orangepi5b = {
            core = import ./modules/boards/orangepi5b.nix;
            sd-image = ./modules/sd-image/orangepi5b.nix;
          };
          # Orange Pi 5 Plus SBC
          orangepi5plus = {
            core = import ./modules/boards/orangepi5plus.nix;
            sd-image = ./modules/sd-image/orangepi5plus.nix;
          };
          # Orange Pi 5 Pro SBC
          orangepi5pro = {
            core = import ./modules/boards/orangepi5pro.nix;
            sd-image = ./modules/sd-image/orangepi5pro.nix;
          };
          # Rock 5 Model A SBC
          rock5a = {
            core = import ./modules/boards/rock5a.nix;
            sd-image = ./modules/sd-image/rock5a.nix;
          };
        };

        formats = { config, ... }: {
          imports = [
            nixos-generators.nixosModules.all-formats
          ];

          nixpkgs.hostPlatform = aarch64System;
          formatConfigs.rk3588-raw-efi = import ./modules/rk3588-raw-efi.nix;
        };
      };

      nixosConfigurations =
        # sdImage - boot via U-Boot - fully native
        (builtins.mapAttrs
          (name: board:
            nixpkgs.lib.nixosSystem {
              system = aarch64System; # native or qemu-emulated
              specialArgs.rk3588 = {
                inherit nixpkgs;
                pkgsKernel = pkgsNative;
              };
              modules = [
                ./modules/configuration.nix
                board.core
                board.sd-image

                {
                  networking.hostName = name;
                  sdImage.imageBaseName = "${name}-sd-image";
                }
              ];
            })
          self.nixosModules.boards)
        # sdImage - boot via U-Boot - fully cross-compiled
        // (nixpkgs.lib.mapAttrs'
          (name: board:
            nixpkgs.lib.nameValuePair
              (name + "-cross")
              (nixpkgs.lib.nixosSystem {
                system = localSystem; # x64
                specialArgs.rk3588 = {
                  inherit nixpkgs;
                  pkgsKernel = pkgsCross;
                };
                modules = [
                  ./modules/configuration.nix
                  board.core
                  board.sd-image

                  {
                    networking.hostName = name;
                    sdImage.imageBaseName = "${name}-sd-image";

                    # Use the cross-compilation toolchain to build the whole system.
                    nixpkgs.crossSystem.config = "aarch64-unknown-linux-gnu";
                  }
                ];
              }))
          self.nixosModules.boards)
        # UEFI system, boot via edk2-rk3588 - fully native
        // (nixpkgs.lib.mapAttrs'
          (name: board:
            nixpkgs.lib.nameValuePair
              (name + "-uefi")
              (nixpkgs.lib.nixosSystem {
                system = aarch64System; # native or qemu-emulated

                specialArgs = {
                  rk3588 = {
                    inherit nixpkgs;
                    pkgsKernel = pkgsNative;
                  };
                  inherit nixos-generators;
                };
                modules = [
                  board.core
                  ./modules/configuration.nix
                  {
                    networking.hostName = name;
                  }

                  self.nixosModules.formats
                ];
              }))
          self.nixosModules.boards);
    }
    // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages = {
        # sdImage
        sdImage-opi5 = self.nixosConfigurations.orangepi5.config.system.build.sdImage;
        sdImage-opi5b = self.nixosConfigurations.orangepi5b.config.system.build.sdImage;
        sdImage-opi5plus = self.nixosConfigurations.orangepi5plus.config.system.build.sdImage;
        sdImage-opi5pro = self.nixosConfigurations.orangepi5pro.config.system.build.sdImage;
        sdImage-rock5a = self.nixosConfigurations.rock5a.config.system.build.sdImage;

        sdImage-opi5-cross = self.nixosConfigurations.orangepi5-cross.config.system.build.sdImage;
        sdImage-opi5b-cross = self.nixosConfigurations.orangepi5b-cross.config.system.build.sdImage;
        sdImage-opi5plus-cross = self.nixosConfigurations.orangepi5plus-cross.config.system.build.sdImage;
        sdImage-opi5pro-cross = self.nixosConfigurations.orangepi5pro-cross.config.system.build.sdImage;
        sdImage-rock5a-cross = self.nixosConfigurations.rock5a-cross.config.system.build.sdImage;

        # UEFI raw image
        rawEfiImage-opi5 = self.nixosConfigurations.orangepi5-uefi.config.formats.rk3588-raw-efi;
        rawEfiImage-opi5plus = self.nixosConfigurations.orangepi5plus-uefi.config.formats.rk3588-raw-efi;
        rawEfiImage-opi5pro = self.nixosConfigurations.orangepi5pro-uefi.config.formats.rk3588-raw-efi;
        rawEfiImage-rock5a = self.nixosConfigurations.rock5a-uefi.config.formats.rk3588-raw-efi;
      };

      devShells.fhsEnv =
        # the code here is mainly copied from:
        #   https://nixos.wiki/wiki/Linux_kernel#Embedded_Linux_Cross-compile_xconfig_and_menuconfig
        (pkgs.buildFHSUserEnv {
          name = "kernel-build-env";
          targetPkgs = pkgs_: (with pkgs_;
            [
              # we need theses packages to make `make menuconfig` work.
              pkg-config
              ncurses
              # arm64 cross-compilation toolchain
              pkgsCross.gccStdenv.cc
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
          alejandra.enable = true;
          statix.enable = true;
        };
      };
    });
}
