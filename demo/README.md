# Demo - Deploy via Colmena

> Colmena is my personal choice mainly for remote deployment, but you can use other tools like `nixos-rebuild switch --flake .#opi5` to deploy your configuration locally. However, I won’t cover them in this guide.

This is a demo of how to deploy NixOS to a remote server (or to localhost) using [colmena](https://github.com/zhaofengli/colmena).

If you're not familiar with remote deployment, please read this tutorial first: [Remote Deployment - NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/best-practices/remote-deployment).

## Configure Deployment Options

We’ve added options to the `flake.nix` to allow for flexible deployment types. You can now choose between UEFI or U-Boot boot configurations, as well as configure your deployment for local or remote compilation.

### Available Options

1. **Boot Type**: Choose between UEFI and U-Boot.

   - Set the `bootType` in `flake.nix`:

     ```nix
     bootType = "uefi";  # Or use "u-boot"
     ```

2. **Compilation Type**: Choose how and where the system will be built.

   - Set the `compilationType` to one of the following:
     - `"local-native"`: Builds natively on the ARM-based device (local).
     - `"remote-native"`: Builds natively on a remote ARM-based device.
     - `"cross"`: Cross-compiles on your x86_64 machine for ARM.

   Example in `flake.nix`:

   ```nix
   compilationType = "cross";  # Options: "local-native", "remote-native", "cross"
   ```

3. **System Architecture**: This is automatically configured based on your chosen compilation type.

### Example Configuration in `flake.nix`

Here’s an example snippet from `flake.nix`:

```nix
bootType = "uefi";  # Options: "uefi" or "u-boot"
compilationType = "cross";  # Options: "local-native", "remote-native", or "cross"
```

---

## Deploy to a Remote Server

To deploy to a remote server, first modify `flake.nix` to set the `bootType` and `compilationType` options to fit your needs.

Then, run the following command to deploy the configuration to your remote server:

> The first time you run this command, it may take 40 minutes to a few hours to build the system, but future builds will be much faster.

```bash
nix run nixpkgs#colmena apply
```

## Deploy Locally

For local native compilation (building the system directly on the device), you can set the compilation type to `"local-native"` in `flake.nix`.

1. Set:

   ```nix
   compilationType = "local-native";
   ```

2. Optionally adjust the boot type (`bootType`) for either UEFI or U-Boot.

Then, run the following command to deploy locally:

```bash
nix run nixpkgs#colmena apply-local
```

---

### Summary of Options

- **bootType**:
  - `"uefi"`: Use UEFI bootloader.
  - `"u-boot"`: Use U-Boot bootloader.
- **compilationType**:
  - `"local-native"`: Native compilation on the local ARM device.
  - `"remote-native"`: Native compilation on a remote ARM device.
  - `"cross"`: Cross-compilation from an x86_64 machine for ARM.

## Real-World Examples

Here are some real-world examples of how to deploy NixOS to your SBCs using flakes:

- <https://github.com/HeroBrine1st/flake>
- <https://github.com/ryan4yin/nixos-config-sbc>
  - Key Differnece: this repo use [disko] to format & mount the disk automatically.

[disko]: https://github.com/nix-community/disko
