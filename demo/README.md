# Demo - Deploy via Colmena

> Colmena is my personal choice mainly for remote deployment, you can use other tools like `nixos-rebuild switch --flake .#opi5` to deploy your configuration, but I won't cover them here.

This is a demo of how to deploy NixOS to a remote server(or to localhost) using [colmena](https://github.com/zhaofengli/colmena).

If you're not familiar with remote deployment, please read this tutorial first: [Remote Deployment - NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/best-practices/remote-deployment)

## Deploy to a remote server

Modify the nix files in this directory to fit your needs.

Then, run the following command to deploy the configuration to your remote server:

> The first time you run this command, it will take a long time(maybe 40 minutes to hours) to build the whole system, but the next time you run it, it will be much faster.

```bash
nix run nixpkgs#colmena apply 
```

## Deploy locally

Modify the nix files in this directory to fit your needs.

To deploy locally, we need to compile the whole system natively on the rk3588 based boards, here is some operations you must make in `flake.nix`:

1. Replace `system = "x86_64-linux";` to `system = "aarch64-linux";`
2. Remove the config related to `nixpkgs.crossSystem`, it's not needed anymore.

Then, run the following command to deploy the configuration locally:

> The first time you run this command, it will take a long time(maybe 40 minutes to hours) to build the whole system, but the next time you run it, it will be much faster.

```bash
nix run nixpkgs#colmena apply-local
```

