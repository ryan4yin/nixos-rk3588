# Linux Kernel

The kernel used in this flake is from [armbian/linux-rockchip/rk-5.10-rkr4](https://github.com/armbian/linux-rockchip/blob/rk-5.10-rkr4), the armbian's developers have done a lot of work to make the kernel work on RK3588/RK3588S based boards.

Other informations:

- the SBC specific build configuration:
  - <https://github.com/armbian/build/blob/a36bb63/config/boards/orangepi5.conf>
  - <https://github.com/armbian/build/blob/ad82607/config/boards/orangepi5-plus.conf>
  - <https://github.com/armbian/build/blob/a36bb63/config/boards/rock-5a.wip>(work in progress)
  - though we do not build u-boot here, but the u-boot's source repo & `BOOTCONFIG` are defined in the above files
    - by default, the u-boot's source repo is determined by `BOARDFAMILY="rockchip-rk3588"`:
      - https://github.com/armbian/build/blob/316c411/config/sources/families/rockchip-rk3588.conf#L11
      - which defined `BOOTSOURCE='https://github.com/radxa/u-boot.git'`
    - for orangepi5/orangepi5plus, the `BOOTSOURCE` is overridden to https://github.com/orangepi-xunlong/u-boot-orangepi.git
- the kernel config:
  - base: <https://github.com/armbian/build/blob/a36bb63/config/kernel/linux-rockchip-rk3588-legacy.config>
  - for boards:
    - <https://github.com/armbian/build/blob/ad82607/config/boards/orangepi5-plus.conf>
      - `./compile.sh build BOARD=orangepi5 BRANCH=legacy BUILD_DESKTOP=no BUILD_MINIMAL=yes KERNEL_CONFIGURE=yes RELEASE=jammy`
- the initial commit for orangepi5 in armbian/build:
  - <https://github.com/armbian/build/commit/18198b1d7d72cbef44228e7cb44a078cb8e03f27#diff-999cd9038268b0c128f7342a957b87fa0b4b12536e4cd2abd54c9a17180188e1>

The SBC's kernel config in this directory is based on the armbian's kernel config listed above.

## References

- [RK3588 Mainline Kernel support - Rockchip RK3588 upstream enablement efforts](https://gitlab.collabora.com/hardware-enablement/rockchip-3588/notes-for-rockchip-3588/-/blob/main/mainline-status.md)
