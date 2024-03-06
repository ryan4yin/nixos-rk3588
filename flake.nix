{
  description = "A minimal NixOS configuration for the RK3588/RK3588S based SBCs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
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

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nixos-generators,
    pre-commit-hooks,
    ...
  }: let
    # Local system's architecture, the host you are running this flake on.
    localSystem = "x86_64-linux";
    # The native system of the target SBC.
    aarch64System = "aarch64-linux";
    pkgsLocal = import nixpkgs {system = localSystem;};
    pkgsCross = import nixpkgs {
      inherit localSystem;
      crossSystem = aarch64System;
    };

    specialArgs = {
      rk3588 = {
        inherit nixpkgs;
        # Compile the kernel using a cross-compilation tool chain
        # Which is faster than emulating the target system.
        pkgsKernel = pkgsCross;
      };
    };
  in
    {
      nixosModules = {
        # Orange Pi 5 SBC
        orangepi5 = {
          core = import ./modules/boards/orangepi5.nix;
          sd-image = ./modules/sd-image/orangepi5.nix;
        };
        # Orange Pi 5 Plus SBC
        orangepi5plus = {
          core = import ./modules/boards/orangepi5plus.nix;
          sd-image = ./modules/sd-image/orangepi5plus.nix;
        };
        # Rock 5 Model A SBC
        rock5a = {
          core = import ./modules/boards/rock5a.nix;
          sd-image = ./modules/sd-image/rock5a.nix;
        };
      };

      nixosConfigurations =
        # sdImage - boot via U-Boot
        (builtins.mapAttrs (name: board:
          nixpkgs.lib.nixosSystem {
            # Use emulated target system here.
            # NOTE: we use pkgsCross for the kernel build only,
            # and emulated the target system for everything else,
            # so that we can use nixos's official binary cache for the rest of the packages.
            system = aarch64System;
            inherit specialArgs;
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
        self.nixosModules)
        # UEFI system, boot via edk2-rk3588
        // (nixpkgs.lib.mapAttrs'
          (name: board:
            nixpkgs.lib.nameValuePair
            (name + "-uefi")
            (nixpkgs.lib.nixosSystem {
              # Use emulated target system here.
              system = aarch64System;
              inherit specialArgs;
              modules = [
                board.core
                ./modules/configuration.nix
                {
                  networking.hostName = name;
                }

                nixos-generators.nixosModules.all-formats
              ];
            }))
          self.nixosModules);
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      kernelPackages = pkgsCross.linuxPackagesFor (pkgsCross.callPackage ../../pkgs/kernel/legacy.nix {});
      pkgs = pkgsLocal;
    in {
      packages = {
        # sdImage
        sdImage-opi5 = self.nixosConfigurations.orangepi5.config.system.build.sdImage;
        sdImage-opi5plus = self.nixosConfigurations.orangepi5plus.config.system.build.sdImage;
        sdImage-rock5a = self.nixosConfigurations.rock5a.config.system.build.sdImage;

        # UEFI raw image
        rawEfiImage-opi5 = self.nixosConfigurations.orangepi5-uefi.config.formats.raw-efi;
        rawEfiImage-opi5plus = self.nixosConfigurations.orangepi5plus-uefi.config.formats.raw-efi;
        rawEfiImage-rock5a = self.nixosConfigurations.rock5a-uefi.config.formats.raw-efi;

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
        kernel = kernelPackages.kernel.dev;
      };

      # use `nix develop .#fhsEnv` to enter the fhs test environment defined here.
      # for kernel debugging
      devShells.fhsEnv =
        # the code here is mainly copied from:
        #   https://nixos.wiki/wiki/Linux_kernel#Embedded_Linux_Cross-compile_xconfig_and_menuconfig
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
        })
        .env;

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
