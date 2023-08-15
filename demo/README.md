# Demo - Remote Deployment

> WIP, use at your own risk.

This is a demo of how to deploy NixOS to a remote server(or to localhost) using [colmena](https://github.com/zhaofengli/colmena).

Modify the nix files in this directory to fit your needs.

Then, run the following command to deploy the configuration to your remote server:

```bash
nix run nixpkgs#colmena apply 

# to deploy to localhost, use this instead:
nix run nixpkgs#colmena apply-local
```

If you're not familiar with remote deployment, please read this tutorial first: [Remote Deployment - NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/best-practices/remote-deployment)

