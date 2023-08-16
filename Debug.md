
## Debug with UART

When the system fails to boot, you can check the boot logs through serial port.

First, connect the USB to TTL cable to the debugging serial port of the board.

Orange Pi 5's debugging serial port:

![](/_img/orangepi5-serialport.webp)

Orange Pi 5 Plus's debugging serial port:

![](/_img/orangepi5plus-serialport.webp)


Rock 5A's do not have a debugging serial port, NixOS will print the boot log to UART0 by default, see the official documentation for the pin definition of UART0: [Rock 5A pinout - Radxa Wiki](https://wiki.radxa.com/Rock5/hardware/5a/gpio)

Then, use tools like 'screen' or 'minicom' to read and write to the serial port device.

```shell
› ls /dev/ttyUSB0
╭───┬──────────────┬─────────────┬──────┬───────────────╮
│ # │     name     │    type     │ size │   modified    │
├───┼──────────────┼─────────────┼──────┼───────────────┤
│ 0 │ /dev/ttyUSB0 │ char device │  0 B │ 6 minutes ago │
╰───┴──────────────┴─────────────┴──────┴───────────────╯

› minicom -d /dev/ttyusb0 -b 1500000
```

If everything is normal, you should be able to see the startup log at this point. An example(orangepi 5) is shown below:

```
Welcome to minicom 2.8

OPTIONS: I18n 
Compiled on Jan  1 1980, 00:00:00.
Port /dev/ttyUSB0, 12:44:24

Press CTRL-A Z for help on special keys

DDR Version V1.08 20220617
LPDDR4X, 2112MHz
channel[0] BW=16 Col=10 Bk=8 CS0 Row=16 CS1 Row=16 CS=2 Die BW=16 Size=2048MB
channel[1] BW=16 Col=10 Bk=8 CS0 Row=16 CS1 Row=16 CS=2 Die BW=16 Size=2048MB
channel[2] BW=16 Col=10 Bk=8 CS0 Row=16 CS1 Row=16 CS=2 Die BW=16 Size=2048MB
channel[3] BW=16 Col=10 Bk=8 CS0 Row=16 CS1 Row=16 CS=2 Die BW=16 Size=2048MB
Manufacturer ID:0x1 Samsung
CH0 RX Vref:33.7%, TX Vref:21.8%,21.8%
CH1 RX Vref:34.7%, TX Vref:20.8%,19.8%
CH2 RX Vref:33.7%, TX Vref:21.8%,21.8%
CH3 RX Vref:31.7%, TX Vref:21.8%,20.8%
change to F1: 528MHz
change to F2: 1068MHz
change to F3: 1560MHz
change to F0: 2112MHz
out
U-Boot SPL board init
U-Boot SPL 2017.09-armbian (May 27 2023 - 19:31:23)
Trying to boot from MMC1
Trying fit image at 0x4000 sector
Not fit magic
Trying fit image at 0x5000 sector
Not fit magic
Trying to boot from MMC2
Card did not respond to voltage select!
spl: mmc init failed with error: -95
Trying to boot from MTD2
Trying fit image at 0x4000 sector
## Verified-boot: 0
## Checking atf-1 0x00040000 ... sha256(806278dba1...) + OK
## Checking uboot 0x00200000 ... sha256(f06a047dd2...) + OK
## Checking fdt 0x00349518 ... sha256(6a0656d703...) + OK
## Checking atf-2 0x000f0000 ... sha256(c00c7fd75b...) + OK
## Checking atf-3 0xff100000 ... sha256(71c3a5841b...) + OK
## Checking atf-4 0xff001000 ... sha256(2301cf73be...) + OK
Jumping to U-Boot(0x00200000) via ARM Trusted Firmware(0x00040000)
Total: 734.711 ms

INFO:    Preloader serial: 2
NOTICE:  BL31: v2.3():v2.3-405-gb52c2eadd:derrick.huang
NOTICE:  BL31: Built : 11:23:47, Aug 15 2022
INFO:    spec: 0x13
INFO:    ext 32k is valid
INFO:    GICv3 without legacy support detected.
INFO:    ARM GICv3 driver initialized in EL3
INFO:    system boots from cpu-hwid-0
INFO:    idle_st=0x21fff, pd_st=0x11fff9, repair_st=0xfff70001
INFO:    dfs DDR fsp_params[0].freq_mhz= 2112MHz
INFO:    dfs DDR fsp_params[1].freq_mhz= 528MHz
INFO:    dfs DDR fsp_params[2].freq_mhz= 1068MHz
INFO:    dfs DDR fsp_params[3].freq_mhz= 1560MHz
INFO:    BL31: Initialising Exception Handling Framework
INFO:    BL31: Initializing runtime services
WARNING: No OPTEE provided by BL2 boot loader, Booting device without OPTEE initialization. SMC`s destined for OPTEE will return SMC_UNK
ERROR:   Error initializing runtime service opteed_fast
INFO:    BL31: Preparing for EL3 exit to normal world
INFO:    Entry point address = 0x200000
INFO:    SPSR = 0x3c9


U-Boot 2017.09-armbian (May 27 2023 - 19:31:23 +0000)

Model: Orange Pi 5
PreSerial: 2, raw, 0xfeb50000
DRAM:  7.7 GiB
Sysmem: init
Relocation Offset: eda2d000
Relocation fdt: eb9f91c8 - eb9fecb0
CR: M/C/I
Using default environment

PCIe-0 Link Fail
mmc@fe2c0000: 0, mmc@fe2e0000: 1

Device 0: unknown device
Card did not respond to voltage select!
switch to partitions #0, OK
mmc0 is current device
Bootdev(scan): mmc 0
MMC0: Legacy, 52Mhz
PartType: DOS
DM: v2
boot mode: None
Model: Orange Pi 5
CLK: (sync kernel. arm: enter 1008000 KHz, init 1008000 KHz, kernel 0N/A)
  b0pll 24000 KHz
  b1pll 24000 KHz
  lpll 24000 KHz
  v0pll 24000 KHz
  aupll 24000 KHz
  cpll 1500000 KHz
  gpll 1188000 KHz
  npll 24000 KHz
  ppll 1100000 KHz
  aclk_center_root 702000 KHz
  pclk_center_root 100000 KHz
  hclk_center_root 396000 KHz
  aclk_center_low_root 500000 KHz
  aclk_top_root 750000 KHz
  pclk_top_root 100000 KHz
  aclk_low_top_root 396000 KHz
Net:   No ethernet found.
Hit key to stop autoboot('CTRL+C'):  0 
switch to partitions #0, OK
mmc0 is current device
mmc@fe2c0000: 0 (SD)
mmc@fe2e0000: 1
switch to partitions #0, OK
mmc0 is current device
Scanning mmc 0:2...
Found /boot/extlinux/extlinux.conf
Retrieving file: /boot/extlinux/extlinux.conf
948 bytes read in 9 ms (102.5 KiB/s)
------------------------------------------------------------
1:      NixOS - Default
Enter choice: 1:        NixOS - Default
Retrieving file: /boot/extlinux/../nixos/1rbfawmy3zijs65y5z3z3n5g1qv0s8i4-initrd-k-aarch64-unknown-linux-gnu-initrd
8990737 bytes read in 733 ms (11.7 MiB/s)
Retrieving file: /boot/extlinux/../nixos/3zq9aa3y6jkjbn4rvnwzwhlc13z5f75g-k-aarch64-unknown-linux-gnu-Image
35179008 bytes read in 7939 ms (4.2 MiB/s)
append: init=/nix/store/2amdg4d4nzr6r0m7sqk77fchmkldw1pv-nixos-system-orangepi5-23.05pre-git/init console=ttyS0,115200n8 console=ttyAMA0,115200n8 console=tty0 root=UUID=14e19a7b-0ae0-484d-9d54-43bd6fdc20c7 root7
Retrieving file: /boot/extlinux/../nixos/a758zd11047zqzrx8m1m1c77smdl8q4p-device-tree-overlays/rockchip/rk3588s-orangepi-5.dtb
234607 bytes read in 160 ms (1.4 MiB/s)
Fdt Ramdisk skip relocation
## Flattened Device Tree blob at 0x0a100000
   Booting using the fdt blob at 0x0a100000
  'reserved-memory' cma: addr=10000000 size=10000000
  'reserved-memory' ramoops@110000: addr=110000 size=f0000
   Using Device Tree in place at 000000000a100000, end 000000000a13c46e
Adding bank: 0x00200000 - 0xf0000000 (size: 0xefe00000)
Adding bank: 0x100000000 - 0x200000000 (size: 0x100000000)
Total: 14886.38 ms

Starting kernel ...

[   14.905596] Booting Linux on physical CPU 0x0000000000 [0x412fd050]
[   14.905620] Linux version 5.10.160 (nixbld@localhost) (aarch64-unknown-linux-gnu-gcc (GCC) 12.2.0, GNU ld (GNU Binutils) 2.40) #1-NixOS SMP Tue Jan 1 00:00:00 UTC 1980
[   14.916175] Machine model: Orange Pi 5
[   14.916408] efi: UEFI not found.
[   14.920054] OF: fdt: Reserved memory: failed to reserve memory for node 'drm-logo@00000000': base 0x0000000000000000, size 0 MiB
[   14.920075] OF: fdt: Reserved memory: failed to reserve memory for node 'drm-cubic-lut@00000000': base 0x0000000000000000, size 0 MiB
[   14.920166] Reserved memory: created CMA memory pool at 0x0000000010000000, size 256 MiB
[   14.920174] OF: reserved mem: initialized node cma, compatible id shared-dma-pool
[   15.073889] Zone ranges:
[   15.073903]   DMA      [mem 0x0000000000200000-0x00000000ffffffff]
[   15.073916]   DMA32    empty
[   15.073925]   Normal   [mem 0x0000000100000000-0x00000001ffffffff]
[   15.073935] Movable zone start for each node
[   15.073940] Early memory node ranges
[   15.073947]   node   0: [mem 0x0000000000200000-0x00000000efffffff]
[   15.073956]   node   0: [mem 0x0000000100000000-0x00000001ffffffff]
[   15.073966] Initmem setup node 0 [mem 0x0000000000200000-0x00000001ffffffff]
[   15.129291] psci: probing for conduit method from DT.
[   15.129306] psci: PSCIv1.1 detected in firmware.
[   15.129312] psci: Using standard PSCI v0.2 function IDs
[   15.129320] psci: MIGRATE_INFO_TYPE not supported.
[   15.129329] psci: SMC Calling Convention v1.2
[   15.129766] percpu: Embedded 32 pages/cpu s93544 r8192 d29336 u131072
[   15.129956] Detected VIPT I-cache on CPU0
[   15.130008] CPU features: detected: GIC system register CPU interface
[   15.130016] CPU features: detected: Virtualization Host Extensions
[   15.130029] CPU features: detected: ARM errata 1165522, 1319367, or 1530923
[   15.130044] alternatives: patching kernel code
[   15.130422] Built 1 zonelists, mobility grouping on.  Total pages: 1999368
[   15.130434] Kernel command line: init=/nix/store/2amdg4d4nzr6r0m7sqk77fchmkldw1pv-nixos-system-orangepi5-23.05pre-git/init console=ttyS0,115200n8 console=ttyAMA0,115200n8 console=tty0 root=UUID=14e19a7b-0ae07
[   15.131748] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes, linear)
[   15.132141] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes, linear)
[   15.132151] mem auto-init: stack:off, heap alloc:off, heap free:off
[   15.138394] software IO TLB: mapped [mem 0x00000000ec000000-0x00000000f0000000] (64MB)
[   15.213046] Memory: 7594976K/8124416K available (17088K kernel code, 3506K rwdata, 6568K rodata, 7040K init, 623K bss, 267296K reserved, 262144K cma-reserved)
[   15.213201] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[   15.213240] ftrace: allocating 65907 entries in 258 pages
[   15.320077] ftrace: allocated 258 pages with 2 groups
[   15.320376] rcu: Hierarchical RCU implementation.
[   15.320385] rcu:     RCU event tracing is enabled.
[   15.320392]  Rude variant of Tasks RCU enabled.
[   15.320397]  Tracing variant of Tasks RCU enabled.
[   15.320404] rcu: RCU calculated value of scheduler-enlistment delay is 30 jiffies.
[   15.325704] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
[   15.328549] GICv3: GIC: Using split EOI/Deactivate mode
[   15.328558] GICv3: 480 SPIs implemented
[   15.328565] GICv3: 0 Extended SPIs implemented
[   15.328597] GICv3: Distributor has no Range Selector support
[   15.328609] GICv3: 16 PPIs implemented
[   15.328656] GICv3: CPU0: found redistributor 0 region 0:0x00000000fe680000
[   15.328789] ITS [mem 0xfe640000-0xfe65ffff]
[   15.328848] ITS@0x00000000fe640000: allocated 8192 Devices @100200000 (indirect, esz 8, psz 64K, shr 0)
[   15.328878] ITS@0x00000000fe640000: allocated 32768 Interrupt Collections @100210000 (flat, esz 2, psz 64K, shr 0)
[   15.328889] ITS: using cache flushing for cmd queue
[   15.328932] ITS [mem 0xfe660000-0xfe67ffff]
[   15.328981] ITS@0x00000000fe660000: allocated 8192 Devices @100230000 (indirect, esz 8, psz 64K, shr 0)
[   15.329010] ITS@0x00000000fe660000: allocated 32768 Interrupt Collections @100240000 (flat, esz 2, psz 64K, shr 0)
[   15.329022] ITS: using cache flushing for cmd queue
[   15.329243] GICv3: using LPI property table @0x0000000100250000
[   15.329370] GIC: using cache flushing for LPI property table
[   15.329382] GICv3: CPU0: using allocated LPI pending table @0x0000000100260000
[   15.459250] arch_timer: cp15 timer(s) running at 24.00MHz (phys).
[   15.459262] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x588fe9dc0, max_idle_ns: 440795202592 ns
[   15.459274] sched_clock: 56 bits at 24MHz, resolution 41ns, wraps every 4398046511097ns
[   15.460613] Console: colour dummy device 80x25
[   15.461278] printk: console [tty0] enabled
[   15.461315] Calibrating delay loop (skipped), value calculated using timer frequency.. 48.00 BogoMIPS (lpj=80000)
[   15.461341] pid_max: default: 32768 minimum: 301
[   15.461458] LSM: Security Framework initializing
[   15.461540] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes, linear)
[   15.461574] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes, linear)
[   15.463702] rcu: Hierarchical SRCU implementation.
[   15.464657] Platform MSI: msi-controller@fe640000 domain created
[   15.464690] Platform MSI: msi-controller@fe660000 domain created
[   15.465077] PCI/MSI: /interrupt-controller@fe600000/msi-controller@fe640000 domain created
[   15.465116] PCI/MSI: /interrupt-controller@fe600000/msi-controller@fe660000 domain created
[   15.465310] EFI services will not be available.
[   15.465769] smp: Bringing up secondary CPUs ...
[   15.466432] Detected VIPT I-cache on CPU1
[   15.466470] GICv3: CPU1: found redistributor 100 region 0:0x00000000fe6a0000
[   15.466491] GICv3: CPU1: using allocated LPI pending table @0x0000000100270000
[   15.466536] CPU1: Booted secondary processor 0x0000000100 [0x412fd050]
[   15.467253] Detected VIPT I-cache on CPU2
[   15.467283] GICv3: CPU2: found redistributor 200 region 0:0x00000000fe6c0000
[   15.467302] GICv3: CPU2: using allocated LPI pending table @0x0000000100280000
[   15.467341] CPU2: Booted secondary processor 0x0000000200 [0x412fd050]
[   15.468047] Detected VIPT I-cache on CPU3
[   15.468075] GICv3: CPU3: found redistributor 300 region 0:0x00000000fe6e0000
[   15.468093] GICv3: CPU3: using allocated LPI pending table @0x0000000100290000
[   15.468131] CPU3: Booted secondary processor 0x0000000300 [0x412fd050]
[   15.468811] CPU features: detected: Spectre-v4
[   15.468814] CPU features: detected: Spectre-BHB
[   15.468817] Detected PIPT I-cache on CPU4
[   15.468832] GICv3: CPU4: found redistributor 400 region 0:0x00000000fe700000
[   15.468842] GICv3: CPU4: using allocated LPI pending table @0x00000001002a0000
[   15.468866] CPU4: Booted secondary processor 0x0000000400 [0x414fd0b0]
[   15.469551] Detected PIPT I-cache on CPU5
[   15.469566] GICv3: CPU5: found redistributor 500 region 0:0x00000000fe720000
[   15.469577] GICv3: CPU5: using allocated LPI pending table @0x00000001002b0000
[   15.469601] CPU5: Booted secondary processor 0x0000000500 [0x414fd0b0]
[   15.470256] Detected PIPT I-cache on CPU6
[   15.470272] GICv3: CPU6: found redistributor 600 region 0:0x00000000fe740000
[   15.470282] GICv3: CPU6: using allocated LPI pending table @0x00000001002c0000
[   15.470306] CPU6: Booted secondary processor 0x0000000600 [0x414fd0b0]
[   15.470952] Detected PIPT I-cache on CPU7
[   15.470968] GICv3: CPU7: found redistributor 700 region 0:0x00000000fe760000
[   15.470978] GICv3: CPU7: using allocated LPI pending table @0x00000001002d0000
[   15.471002] CPU7: Booted secondary processor 0x0000000700 [0x414fd0b0]
[   15.471076] smp: Brought up 1 node, 8 CPUs
[   15.471378] SMP: Total of 8 processors activated.
[   15.471391] CPU features: detected: Privileged Access Never
[   15.471404] CPU features: detected: User Access Override
[   15.471417] CPU features: detected: 32-bit EL0 Support
[   15.471430] CPU features: detected: Common not Private translations
[   15.471444] CPU features: detected: RAS Extension Support
[   15.471456] CPU features: detected: Data cache clean to the PoU not required for I/D coherence
[   15.471474] CPU features: detected: CRC32 instructions
[   15.471486] CPU features: detected: Speculative Store Bypassing Safe (SSBS)
[   15.471503] CPU features: detected: RCpc load-acquire (LDAPR)
[   15.471591] CPU: All CPU(s) started at EL2
[   15.474757] devtmpfs: initialized
[   15.488702] Registered cp15_barrier emulation handler
[   15.488716] Registered setend emulation handler
[   15.488723] KASLR disabled due to lack of seed
[   15.488807] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 6370867519511994 ns
[   15.488820] futex hash table entries: 2048 (order: 5, 131072 bytes, linear)
[   15.491438] pinctrl core: initialized pinctrl subsystem
[   15.491669] DMI not present or invalid.
[   15.491956] NET: Registered protocol family 16
[   15.492994] DMA: preallocated 1024 KiB GFP_KERNEL pool for atomic allocations
[   15.493117] DMA: preallocated 1024 KiB GFP_KERNEL|GFP_DMA pool for atomic allocations
[   15.493145] audit: initializing netlink subsys (disabled)
[   15.493231] audit: type=2000 audit(0.033:1): state=initialized audit_enabled=0 res=1
[   15.493711] Registered FIQ tty driver
[   15.493859] thermal_sys: Registered thermal governor 'fair_share'
[   15.493861] thermal_sys: Registered thermal governor 'step_wise'
[   15.493867] thermal_sys: Registered thermal governor 'user_space'
[   15.493872] thermal_sys: Registered thermal governor 'power_allocator'
[   15.494177] cpuidle: using governor menu
[   15.494422] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
[   15.494555] ASID allocator initialised with 65536 entries
[   15.495968] ramoops: dmesg-0 0x20000@0x0000000000110000
[   15.495988] ramoops: console 0x80000@0x0000000000130000
[   15.496002] ramoops: pmsg    0x50000@0x00000000001b0000
[   15.496264] printk: console [ramoops-1] enabled
[   15.496269] pstore: Registered ramoops as persistent store backend
[   15.496276] ramoops: using 0xf0000@0x110000, ecc: 0
[   15.546310] rockchip-gpio fd8a0000.gpio: probed /pinctrl/gpio@fd8a0000
[   15.546585] rockchip-gpio fec20000.gpio: probed /pinctrl/gpio@fec20000
[   15.546807] rockchip-gpio fec30000.gpio: probed /pinctrl/gpio@fec30000
[   15.547050] rockchip-gpio fec40000.gpio: probed /pinctrl/gpio@fec40000
[   15.547314] rockchip-gpio fec50000.gpio: probed /pinctrl/gpio@fec50000
[   15.547365] rockchip-pinctrl pinctrl: probed pinctrl
[   15.555367] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[   15.555378] HugeTLB registered 32.0 MiB page size, pre-allocated 0 pages
[   15.555385] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[   15.555392] HugeTLB registered 64.0 KiB page size, pre-allocated 0 pages
[   15.615898] raid6: neonx8   gen()  6478 MB/s
[   15.672647] raid6: neonx8   xor()  4865 MB/s
[   15.729398] raid6: neonx4   gen()  6374 MB/s
[   15.786146] raid6: neonx4   xor()  4936 MB/s
[   15.842895] raid6: neonx2   gen()  5330 MB/s
[   15.899647] raid6: neonx2   xor()  4220 MB/s
[   15.956397] raid6: neonx1   gen()  4128 MB/s
[   16.013144] raid6: neonx1   xor()  3559 MB/s
[   16.069901] raid6: int64x8  gen()  1399 MB/s
[   16.126649] raid6: int64x8  xor()   909 MB/s
[   16.183394] raid6: int64x4  gen()  1770 MB/s
[   16.240146] raid6: int64x4  xor()   967 MB/s
[   16.296895] raid6: int64x2  gen()  2523 MB/s
[   16.353647] raid6: int64x2  xor()  1373 MB/s
[   16.410403] raid6: int64x1  gen()  2050 MB/s
[   16.467155] raid6: int64x1  xor()   979 MB/s
[   16.467161] raid6: using algorithm neonx8 gen() 6478 MB/s
[   16.467166] raid6: .... xor() 4865 MB/s, rmw enabled
[   16.467172] raid6: using neon recovery algorithm
[   16.467230] ACPI: Interpreter disabled.
[   16.467791] fiq_debugger fiq_debugger.0: IRQ fiq not found
[   16.467803] fiq_debugger fiq_debugger.0: IRQ wakeup not found
[   16.467811] fiq_debugger_probe: could not install nmi irq handler
[   16.468075] printk: console [ttyFIQ0] enabled
[   16.468179] Registered fiq debugger ttyFIQ0
[   16.468523] vcc5v0_sys: supplied by vcc12v_dcin
[   16.468655] vcc5v0_usbdcin: supplied by vcc12v_dcin
[   16.468786] vcc5v0_usb: supplied by vcc5v0_usbdcin
[   16.469013] vbus5v0_typec: supplied by vcc5v0_usb
[   16.469104] vcc_1v1_nldo_s3: supplied by vcc5v0_sys
[   16.469242] vcc3v3_pcie2x1l2: supplied by vcc5v0_sys
[   16.525368] iommu: Default domain type: Translated 
[   16.529476] SCSI subsystem initialized
[   16.529569] usbcore: registered new interface driver usbfs
[   16.529589] usbcore: registered new interface driver hub
[   16.529609] usbcore: registered new device driver usb
[   16.529652] mc: Linux media interface: v0.10
[   16.529666] videodev: Linux video capture interface: v2.00
[   16.529697] pps_core: LinuxPPS API ver. 1 registered
[   16.529703] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[   16.529714] PTP clock support registered
[   16.529977] arm-scmi firmware:scmi: SCMI Notifications - Core Enabled.
[   16.530014] arm-scmi firmware:scmi: SCMI Protocol v2.0 'rockchip:' Firmware version 0x0
[   16.531175] Advanced Linux Sound Architecture Driver Initialized.
[   16.531421] Bluetooth: Core ver 2.22
[   16.531439] NET: Registered protocol family 31
[   16.531445] Bluetooth: HCI device and connection manager initialized
[   16.531454] Bluetooth: HCI socket layer initialized
[   16.531461] Bluetooth: L2CAP socket layer initialized
[   16.531471] Bluetooth: SCO socket layer initialized
[   16.531486] NetLabel: Initializing
[   16.531492] NetLabel:  domain hash size = 128
[   16.531497] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[   16.531525] NetLabel:  unlabeled traffic allowed by default
[   16.532855] rockchip-cpuinfo cpuinfo: SoC            : 35881000
[   16.532865] rockchip-cpuinfo cpuinfo: Serial         : 8b70cba3356497bc
[   16.533312] clocksource: Switched to clocksource arch_sys_counter
[   16.913428] VFS: Disk quotas dquot_6.6.0
[   16.913469] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   16.913586] pnp: PnP ACPI: disabled
[   16.918795] NET: Registered protocol family 2
[   16.918922] IP idents hash table entries: 131072 (order: 8, 1048576 bytes, linear)
[   16.920853] tcp_listen_portaddr_hash hash table entries: 4096 (order: 5, 163840 bytes, linear)
[   16.920957] TCP established hash table entries: 65536 (order: 7, 524288 bytes, linear)
[   16.921291] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes, linear)
[   16.922029] TCP: Hash tables configured (established 65536 bind 65536)
[   16.922136] MPTCP token hash table entries: 8192 (order: 6, 393216 bytes, linear)
[   16.922235] UDP hash table entries: 4096 (order: 6, 393216 bytes, linear)
[   16.922385] UDP-Lite hash table entries: 4096 (order: 6, 393216 bytes, linear)
[   16.922594] NET: Registered protocol family 1
[   16.922949] RPC: Registered named UNIX socket transport module.
[   16.922957] RPC: Registered udp transport module.
[   16.922962] RPC: Registered tcp transport module.
[   16.922967] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   16.923426] PCI: CLS 0 bytes, default 64
[   16.923709] Trying to unpack rootfs image as initramfs...
[   17.064253] Freeing initrd memory: 8780K
[   17.064955] rockchip-thermal fec00000.tsadc: Missing rockchip,grf property
[   17.065592] rockchip-thermal fec00000.tsadc: tsadc is probed successfully!
[   17.066532] hw perfevents: enabled with armv8_pmuv3 PMU driver, 7 counters available
[   17.067132] kvm [1]: IPA Size Limit: 40 bits
[   17.067147] kvm [1]: GICv3: no GICV resource entry
[   17.067153] kvm [1]: disabling GICv2 emulation
[   17.067159] kvm [1]: GIC system register CPU interface enabled
[   17.067316] kvm [1]: vgic interrupt IRQ9
[   17.067496] kvm [1]: VHE mode initialized successfully
[   17.070386] Initialise system trusted keyrings
[   17.070501] workingset: timestamp_bits=46 max_order=21 bucket_order=0
[   17.073295] NFS: Registering the id_resolver key type
[   17.073323] Key type id_resolver registered
[   17.073329] Key type id_legacy registered
[   17.073368] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[   17.073375] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Driver Registering...
[   17.073391] ntfs: driver 2.1.32 [Flags: R/W].
[   17.094023] NET: Registered protocol family 38
[   17.094036] xor: measuring software checksum speed
[   17.095572]    8regs           :  6494 MB/sec
[   17.096726]    32regs          :  8635 MB/sec
[   17.097670]    arm64_neon      : 10519 MB/sec
[   17.097677] xor: using function: arm64_neon (10519 MB/sec)
[   17.097685] Key type asymmetric registered
[   17.097691] Asymmetric key parser 'x509' registered
[   17.097711] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 242)
[   17.097842] io scheduler mq-deadline registered
[   17.097851] io scheduler kyber registered
[   17.105486] rockchip-hdptx-phy-hdmi fed60000.hdmiphy: hdptx phy init success
[   17.107783] pwm-backlight backlight: supply power not found, using dummy regulator
[   17.107962] pwm-backlight backlight_1: supply power not found, using dummy regulator
[   17.108212] iep: Module initialized.
[   17.108251] mpp_service mpp-srv: unknown mpp version for missing VCS info
[   17.108259] mpp_service mpp-srv: probe start
[   17.110204] mpp_vdpu2 fdb50400.vdpu: Adding to iommu group 1
[   17.110416] mpp_vdpu2 fdb50400.vdpu: probe device
[   17.110530] mpp_vdpu2 fdb50400.vdpu: reset_group->rw_sem_on=0
[   17.110541] mpp_vdpu2 fdb50400.vdpu: reset_group->rw_sem_on=0
[   17.110674] mpp_vdpu2 fdb50400.vdpu: probing finish
[   17.110888] mpp_vepu2 jpege-ccu: probing start
[   17.110897] mpp_vepu2 jpege-ccu: probing finish
[   17.111006] mpp_vepu2 fdb50000.vepu: Adding to iommu group 1
[   17.111089] mpp_vepu2 fdb50000.vepu: probing start
[   17.111180] mpp_vepu2 fdb50000.vepu: reset_group->rw_sem_on=0
[   17.111188] mpp_vepu2 fdb50000.vepu: reset_group->rw_sem_on=0
[   17.111309] mpp_vepu2 fdb50000.vepu: probing finish
[   17.111429] mpp_vepu2 fdba0000.jpege-core: Adding to iommu group 5
[   17.111568] mpp_vepu2 fdba0000.jpege-core: probing start
[   17.111671] mpp_vepu2 fdba0000.jpege-core: attach ccu success
[   17.111815] mpp_vepu2 fdba0000.jpege-core: probing finish
[   17.111925] mpp_vepu2 fdba4000.jpege-core: Adding to iommu group 6
[   17.112061] mpp_vepu2 fdba4000.jpege-core: probing start
[   17.112165] mpp_vepu2 fdba4000.jpege-core: attach ccu success
[   17.112299] mpp_vepu2 fdba4000.jpege-core: probing finish
[   17.112407] mpp_vepu2 fdba8000.jpege-core: Adding to iommu group 7
[   17.112545] mpp_vepu2 fdba8000.jpege-core: probing start
[   17.112648] mpp_vepu2 fdba8000.jpege-core: attach ccu success
[   17.112780] mpp_vepu2 fdba8000.jpege-core: probing finish
[   17.112876] mpp_vepu2 fdbac000.jpege-core: Adding to iommu group 8
[   17.113013] mpp_vepu2 fdbac000.jpege-core: probing start
[   17.113113] mpp_vepu2 fdbac000.jpege-core: attach ccu success
[   17.113247] mpp_vepu2 fdbac000.jpege-core: probing finish
[   17.113530] mpp-iep2 fdbb0000.iep: Adding to iommu group 9
[   17.113671] mpp-iep2 fdbb0000.iep: probe device
[   17.113791] mpp-iep2 fdbb0000.iep: allocate roi buffer failed
[   17.113920] mpp-iep2 fdbb0000.iep: probing finish
[   17.114145] mpp_jpgdec fdb90000.jpegd: Adding to iommu group 4
[   17.114345] mpp_jpgdec fdb90000.jpegd: probe device
[   17.114585] mpp_jpgdec fdb90000.jpegd: probing finish
[   17.114945] mpp_rkvdec2 fdc30000.rkvdec-ccu: rkvdec-ccu, probing start
[   17.115008] mpp_rkvdec2 fdc30000.rkvdec-ccu: ccu-mode: 1
[   17.115015] mpp_rkvdec2 fdc30000.rkvdec-ccu: probing finish
[   17.115110] mpp_rkvdec2 fdc38100.rkvdec-core: Adding to iommu group 12
[   17.115362] mpp_rkvdec2 fdc38100.rkvdec-core: rkvdec-core, probing start
[   17.115483] mpp_rkvdec2 fdc38100.rkvdec-core: shared_niu_a is not found!
[   17.115491] rkvdec2_init:1022: No niu aclk reset resource define
[   17.115498] mpp_rkvdec2 fdc38100.rkvdec-core: shared_niu_h is not found!
[   17.115505] rkvdec2_init:1025: No niu hclk reset resource define
[   17.115535] mpp_rkvdec2 fdc38100.rkvdec-core: no regulator, devfreq is disabled
[   17.115595] mpp_rkvdec2 fdc38100.rkvdec-core: core_mask=00010001
[   17.115602] mpp_rkvdec2 fdc38100.rkvdec-core: attach ccu as core 0
[   17.115754] mpp_rkvdec2 fdc38100.rkvdec-core: sram_start 0x00000000ff001000
[   17.115762] mpp_rkvdec2 fdc38100.rkvdec-core: rcb_iova 0x00000000fff00000
[   17.115769] mpp_rkvdec2 fdc38100.rkvdec-core: sram_size 491520
[   17.115776] mpp_rkvdec2 fdc38100.rkvdec-core: rcb_size 1048576
[   17.115784] mpp_rkvdec2 fdc38100.rkvdec-core: min_width 512
[   17.115792] mpp_rkvdec2 fdc38100.rkvdec-core: rcb_info_count 20
[   17.115798] mpp_rkvdec2 fdc38100.rkvdec-core: [136, 24576]
[   17.115805] mpp_rkvdec2 fdc38100.rkvdec-core: [137, 49152]
[   17.115812] mpp_rkvdec2 fdc38100.rkvdec-core: [141, 90112]
[   17.115818] mpp_rkvdec2 fdc38100.rkvdec-core: [140, 49152]
[   17.115824] mpp_rkvdec2 fdc38100.rkvdec-core: [139, 180224]
[   17.115831] mpp_rkvdec2 fdc38100.rkvdec-core: [133, 49152]
[   17.115838] mpp_rkvdec2 fdc38100.rkvdec-core: [134, 8192]
[   17.115844] mpp_rkvdec2 fdc38100.rkvdec-core: [135, 4352]
[   17.115850] mpp_rkvdec2 fdc38100.rkvdec-core: [138, 13056]
[   17.115856] mpp_rkvdec2 fdc38100.rkvdec-core: [142, 291584]
[   17.115890] mpp_rkvdec2 fdc38100.rkvdec-core: probing finish
[   17.115979] mpp_rkvdec2 fdc48100.rkvdec-core: Adding to iommu group 13
[   17.116204] mpp_rkvdec2 fdc48100.rkvdec-core: rkvdec-core, probing start
[   17.116328] mpp_rkvdec2 fdc48100.rkvdec-core: shared_niu_a is not found!
[   17.116336] rkvdec2_init:1022: No niu aclk reset resource define
[   17.116343] mpp_rkvdec2 fdc48100.rkvdec-core: shared_niu_h is not found!
[   17.116349] rkvdec2_init:1025: No niu hclk reset resource define
[   17.116377] mpp_rkvdec2 fdc48100.rkvdec-core: no regulator, devfreq is disabled
[   17.116423] mpp_rkvdec2 fdc48100.rkvdec-core: core_mask=00020002
[   17.116443] mpp_rkvdec2 fdc48100.rkvdec-core: attach ccu as core 1
[   17.116616] mpp_rkvdec2 fdc48100.rkvdec-core: sram_start 0x00000000ff079000
[   17.116624] mpp_rkvdec2 fdc48100.rkvdec-core: rcb_iova 0x00000000ffe00000
[   17.116631] mpp_rkvdec2 fdc48100.rkvdec-core: sram_size 487424
[   17.116637] mpp_rkvdec2 fdc48100.rkvdec-core: rcb_size 1048576
[   17.116657] mpp_rkvdec2 fdc48100.rkvdec-core: min_width 512
[   17.116665] mpp_rkvdec2 fdc48100.rkvdec-core: rcb_info_count 20
[   17.116672] mpp_rkvdec2 fdc48100.rkvdec-core: [136, 24576]
[   17.116678] mpp_rkvdec2 fdc48100.rkvdec-core: [137, 49152]
[   17.116685] mpp_rkvdec2 fdc48100.rkvdec-core: [141, 90112]
[   17.116691] mpp_rkvdec2 fdc48100.rkvdec-core: [140, 49152]
[   17.116698] mpp_rkvdec2 fdc48100.rkvdec-core: [139, 180224]
[   17.116704] mpp_rkvdec2 fdc48100.rkvdec-core: [133, 49152]
[   17.116710] mpp_rkvdec2 fdc48100.rkvdec-core: [134, 8192]
[   17.116717] mpp_rkvdec2 fdc48100.rkvdec-core: [135, 4352]
[   17.116724] mpp_rkvdec2 fdc48100.rkvdec-core: [138, 13056]
[   17.116730] mpp_rkvdec2 fdc48100.rkvdec-core: [142, 291584]
[   17.116763] mpp_rkvdec2 fdc48100.rkvdec-core: probing finish
[   17.116949] mpp_rkvenc2 rkvenc-ccu: probing start
[   17.116958] mpp_rkvenc2 rkvenc-ccu: probing finish
[   17.117074] mpp_rkvenc2 fdbd0000.rkvenc-core: Adding to iommu group 10
[   17.117253] mpp_rkvenc2 fdbd0000.rkvenc-core: probing start
[   17.117412] mpp_rkvenc2 fdbd0000.rkvenc-core: dev_pm_opp_set_regulators: no regulator (venc) found: -19
[   17.117436] rkvenc_init:1814: failed to add venc devfreq
[   17.117466] mpp_rkvenc2 fdbd0000.rkvenc-core: attach ccu as core 0
[   17.117616] mpp_rkvenc2 fdbd0000.rkvenc-core: probing finish
[   17.117698] mpp_rkvenc2 fdbe0000.rkvenc-core: Adding to iommu group 11
[   17.117879] mpp_rkvenc2 fdbe0000.rkvenc-core: probing start
[   17.118015] mpp_rkvenc2 fdbe0000.rkvenc-core: dev_pm_opp_set_regulators: no regulator (venc) found: -19
[   17.118032] rkvenc_init:1814: failed to add venc devfreq
[   17.118084] mpp_rkvenc2 fdbe0000.rkvenc-core: attach ccu as core 1
[   17.118219] mpp_rkvenc2 fdbe0000.rkvenc-core: probing finish
[   17.118760] mpp_av1dec: Adding child /av1d@fdc70000
[   17.118841] mpp_av1dec: register device av1d-master
[   17.118876] mpp_av1dec av1d-master: av1_iommu_of_xlate,784
[   17.118898] av1_iommu_probe_device,736, consumer : av1d-master, supplier : fdca0000.iommu
[   17.118935] mpp_av1dec av1d-master: Adding to iommu group 18
[   17.119163] mpp_av1dec av1d-master: probing start
[   17.119413] mpp_av1dec av1d-master: probing finish
[   17.119455] mpp_service mpp-srv: probe success
[   17.130033] dma-pl330 fea10000.dma-controller: Loaded driver for PL330 DMAC-241330
[   17.130049] dma-pl330 fea10000.dma-controller:       DBUFF-128x8bytes Num_Chans-8 Num_Peri-32 Num_Events-16
[   17.130987] dma-pl330 fea30000.dma-controller: Loaded driver for PL330 DMAC-241330
[   17.131001] dma-pl330 fea30000.dma-controller:       DBUFF-128x8bytes Num_Chans-8 Num_Peri-32 Num_Events-16
[   17.131917] dma-pl330 fed10000.dma-controller: Loaded driver for PL330 DMAC-241330
[   17.131931] dma-pl330 fed10000.dma-controller:       DBUFF-128x8bytes Num_Chans-8 Num_Peri-32 Num_Events-16
[   17.132404] rockchip-pvtm fda40000.pvtm: pvtm@0 probed
[   17.132469] rockchip-pvtm fda50000.pvtm: pvtm@1 probed
[   17.132529] rockchip-pvtm fda60000.pvtm: pvtm@2 probed
[   17.132596] rockchip-pvtm fdaf0000.pvtm: pvtm@3 probed
[   17.132652] rockchip-pvtm fdb30000.pvtm: pvtm@4 probed
[   17.133212] rockchip-system-monitor rockchip-system-monitor: system monitor probe
[   17.134079] Serial: 8250/16550 driver, 10 ports, IRQ sharing disabled
[   17.134696] febc0000.serial: ttyS9 at MMIO 0xfebc0000 (irq = 98, base_baud = 1500000) is a 16550A
[   17.135956] random: crng init done
[   17.136156] led_vk2c21_init
[   17.136156] =============================================
[   17.137132] rockchip-vop2 fdd90000.vop: Adding to iommu group 17
[   17.145223] rockchip-vop2 fdd90000.vop: [drm:vop2_bind] vp0 assign plane mask: 0x5, primary plane phy id: 0
[   17.145241] rockchip-vop2 fdd90000.vop: [drm:vop2_bind] vp1 assign plane mask: 0xa, primary plane phy id: 1
[   17.145254] rockchip-vop2 fdd90000.vop: [drm:vop2_bind] vp2 assign plane mask: 0x140, primary plane phy id: 6
[   17.145267] rockchip-vop2 fdd90000.vop: [drm:vop2_bind] vp3 assign plane mask: 0x280, primary plane phy id: 7
[   17.145361] rockchip-vop2 fdd90000.vop: [drm:vop2_bind] Esmart0-win0 as cursor plane for vp0
[   17.145453] rockchip-vop2 fdd90000.vop: [drm:vop2_bind] Esmart1-win0 as cursor plane for vp1
[   17.145542] rockchip-vop2 fdd90000.vop: [drm:vop2_bind] Esmart2-win0 as cursor plane for vp2
[   17.145627] rockchip-vop2 fdd90000.vop: [drm:vop2_bind] Esmart3-win0 as cursor plane for vp3
[   17.145651] [drm] failed to init overlay plane Cluster0-win1
[   17.145658] [drm] failed to init overlay plane Cluster1-win1
[   17.145665] [drm] failed to init overlay plane Cluster2-win1
[   17.145672] [drm] failed to init overlay plane Cluster3-win1
[   17.156419] rockchip-drm display-subsystem: bound fdd90000.vop (ops 0xffff8000091faae8)
[   17.157146] dwhdmi-rockchip fde80000.hdmi: registered ddc I2C bus driver
[   17.157360] rockchip-drm display-subsystem: bound fde80000.hdmi (ops 0xffff800009208c40)
[   17.157445] rockchip-drm display-subsystem: bound fde50000.dp (ops 0xffff80000920b6b8)
[   17.157954] rockchip-drm display-subsystem: failed to parse loader memory
[   17.158036] rockchip-drm display-subsystem: [drm] Cannot find any crtc or sizes
[   17.158119] rockchip-drm display-subsystem: [drm] Cannot find any crtc or sizes
[   17.158149] rockchip-drm display-subsystem: [drm] Cannot find any crtc or sizes
[   17.158611] [drm] Initialized rockchip 3.0.0 20140818 for display-subsystem on minor 0
[   17.164988] brd: module loaded
[   17.168501] loop: module loaded
[   17.168738] zram: Added device: zram0
[   17.168882] lkdtm: No crash points registered, enable through debugfs
[   17.168991] system_heap: orders[0] = 6
[   17.168999] system_heap: orders[1] = 4
[   17.169005] system_heap: orders[2] = 0
[   17.170325] ahci fe210000.sata: supply ahci not found, using dummy regulator
[   17.170412] ahci fe210000.sata: supply phy not found, using dummy regulator
[   17.170546] ahci fe210000.sata: supply target not found, using dummy regulator
[   17.170627] ahci fe210000.sata: forcing port_map 0x0 -> 0x1
[   17.170653] ahci fe210000.sata: AHCI 0001.0300 32 slots 1 ports 6 Gbps 0x1 impl platform mode
[   17.170665] ahci fe210000.sata: flags: ncq sntf pm led clo only pmp fbs pio slum part ccc apst 
[   17.170680] ahci fe210000.sata: port 0 can do FBS, forcing FBSCP
[   17.171446] scsi host0: ahci
[   17.171587] ata1: SATA max UDMA/133 mmio [mem 0xfe210000-0xfe210fff] port 0x100 irq 84
[   17.172763] rockchip-spi feb20000.spi: no high_speed pinctrl state
[   17.174205] rk806 spi2.0: chip id: RK806,ver:0x2, 0x1
[   17.174467] rk806 spi2.0: ON: 0x40 OFF:0x0
[   17.176615] vdd_gpu_s0: supplied by vcc5v0_sys
[   17.177792] vdd_cpu_lit_s0: supplied by vcc5v0_sys
[   17.178554] vdd_log_s0: supplied by vcc5v0_sys
[   17.179249] vdd_vdenc_s0: supplied by vcc5v0_sys
[   17.180009] vdd_ddr_s0: supplied by vcc5v0_sys
[   17.180463] vdd2_ddr_s3: supplied by vcc5v0_sys
[   17.181105] vdd_2v0_pldo_s3: supplied by vcc5v0_sys
[   17.181687] vcc_3v3_s3: supplied by vcc5v0_sys
[   17.182249] vddq_ddr_s0: supplied by vcc5v0_sys
[   17.182891] vcc_1v8_s3: supplied by vcc5v0_sys
[   17.183550] vdd_0v75_s3: supplied by vcc_1v1_nldo_s3
[   17.184200] vdd_ddr_pll_s0: supplied by vcc_1v1_nldo_s3
[   17.184703] avdd_0v75_s0: Bringing 750000uV into 837500-837500uV
[   17.185019] avdd_0v75_s0: supplied by vcc_1v1_nldo_s3
[   17.185599] vdd_0v85_s0: supplied by vcc_1v1_nldo_s3
[   17.186167] vdd_0v75_s0: supplied by vcc_1v1_nldo_s3
[   17.186843] avcc_1v8_s0: supplied by vdd_2v0_pldo_s3
[   17.187548] vcc_1v8_s0: supplied by vdd_2v0_pldo_s3
[   17.188189] avdd_1v2_s0: supplied by vdd_2v0_pldo_s3
[   17.188823] vcc_3v3_s0: supplied by vcc5v0_sys
[   17.189397] vccio_sd_s0: supplied by vcc5v0_sys
[   17.189984] pldo6_s3: supplied by vcc5v0_sys
[   17.190543] rk806 spi2.0: no sleep-setting state
[   17.190554] rk806 spi2.0: no reset-setting pinctrl state
[   17.190562] rk806 spi2.0: no dvs-setting pinctrl state
[   17.192579] rockchip-spi feb20000.spi: register misc device rkspi-dev2
[   17.192591] rockchip-spi feb20000.spi: probed, poll=0, rsd=0
[   17.194003] spi-nor spi5.0: XM25QU128C (16384 Kbytes) read_data x4
[   17.194029] 1 fixed-partitions partitions found on MTD device sfc_nor
[   17.194037] Creating 1 MTD partitions on "sfc_nor":
[   17.194046] 0x000000000000-0x000001000000 : "loader"
[   17.195951] rk_gmac-dwmac fe1c0000.ethernet: IRQ eth_lpi not found
[   17.196124] rk_gmac-dwmac fe1c0000.ethernet: no regulator found
[   17.196136] rk_gmac-dwmac fe1c0000.ethernet: clock input or output? (output).
[   17.196145] rk_gmac-dwmac fe1c0000.ethernet: TX delay(0x42).
[   17.196154] rk_gmac-dwmac fe1c0000.ethernet: Can not read property: rx_delay.
[   17.196162] rk_gmac-dwmac fe1c0000.ethernet: set rx_delay to 0xffffffff
[   17.196175] rk_gmac-dwmac fe1c0000.ethernet: integrated PHY? (no).
[   17.196185] rk_gmac-dwmac fe1c0000.ethernet: cannot get clock mac_clk_rx
[   17.196195] rk_gmac-dwmac fe1c0000.ethernet: cannot get clock mac_clk_tx
[   17.196215] rk_gmac-dwmac fe1c0000.ethernet: cannot get clock clk_mac_speed
[   17.196440] rk_gmac-dwmac fe1c0000.ethernet: init for RGMII_RXID
[   17.196542] rk_gmac-dwmac fe1c0000.ethernet: User ID: 0x30, Synopsys ID: 0x51
[   17.196553] rk_gmac-dwmac fe1c0000.ethernet:         DWMAC4/5
[   17.196562] rk_gmac-dwmac fe1c0000.ethernet: DMA HW capability register supported
[   17.196571] rk_gmac-dwmac fe1c0000.ethernet: RX Checksum Offload Engine supported
[   17.196580] rk_gmac-dwmac fe1c0000.ethernet: TX Checksum insertion supported
[   17.196589] rk_gmac-dwmac fe1c0000.ethernet: Wake-Up On Lan supported
[   17.196627] rk_gmac-dwmac fe1c0000.ethernet: TSO supported
[   17.196636] rk_gmac-dwmac fe1c0000.ethernet: Enable RX Mitigation via HW Watchdog Timer
[   17.196661] rk_gmac-dwmac fe1c0000.ethernet: Enabled Flow TC (entries=2)
[   17.196670] rk_gmac-dwmac fe1c0000.ethernet: TSO feature enabled
[   17.196678] rk_gmac-dwmac fe1c0000.ethernet: Using 32 bits DMA width
[   17.331939] usbcore: registered new interface driver rndis_wlan
[   17.331970] usbcore: registered new interface driver asix
[   17.331990] usbcore: registered new interface driver cdc_ether
[   17.332010] usbcore: registered new interface driver rndis_host
[   17.332037] usbcore: registered new interface driver cdc_ncm
[   17.338388] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   17.338410] ehci-pci: EHCI PCI platform driver
[   17.338442] ehci-platform: EHCI generic platform driver
[   17.340430] ehci-platform fc800000.usb: EHCI Host Controller
[   17.340458] ehci-platform fc800000.usb: new USB bus registered, assigned bus number 1
[   17.340540] ehci-platform fc800000.usb: irq 20, io mem 0xfc800000
[   17.353328] ehci-platform fc800000.usb: USB 2.0 started, EHCI 1.00
[   17.353454] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.10
[   17.353467] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   17.353477] usb usb1: Product: EHCI Host Controller
[   17.353485] usb usb1: Manufacturer: Linux 5.10.160 ehci_hcd
[   17.353493] usb usb1: SerialNumber: fc800000.usb
[   17.353760] hub 1-0:1.0: USB hub found
[   17.353783] hub 1-0:1.0: 1 port detected
[   17.356161] ehci-platform fc880000.usb: EHCI Host Controller
[   17.356180] ehci-platform fc880000.usb: new USB bus registered, assigned bus number 2
[   17.356244] ehci-platform fc880000.usb: irq 22, io mem 0xfc880000
[   17.366660] ehci-platform fc880000.usb: USB 2.0 started, EHCI 1.00
[   17.366763] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.10
[   17.366775] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   17.366785] usb usb2: Product: EHCI Host Controller
[   17.366792] usb usb2: Manufacturer: Linux 5.10.160 ehci_hcd
[   17.366800] usb usb2: SerialNumber: fc880000.usb
[   17.367003] hub 2-0:1.0: USB hub found
[   17.367025] hub 2-0:1.0: 1 port detected
[   17.367411] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   17.367428] ohci-platform: OHCI generic platform driver
[   17.367592] ohci-platform fc840000.usb: Generic Platform OHCI controller
[   17.367608] ohci-platform fc840000.usb: new USB bus registered, assigned bus number 3
[   17.367658] ohci-platform fc840000.usb: irq 21, io mem 0xfc840000
[   17.427414] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 5.10
[   17.427430] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   17.427440] usb usb3: Product: Generic Platform OHCI controller
[   17.427448] usb usb3: Manufacturer: Linux 5.10.160 ohci_hcd
[   17.427456] usb usb3: SerialNumber: fc840000.usb
[   17.427653] hub 3-0:1.0: USB hub found
[   17.427676] hub 3-0:1.0: 1 port detected
[   17.427943] ohci-platform fc8c0000.usb: Generic Platform OHCI controller
[   17.427960] ohci-platform fc8c0000.usb: new USB bus registered, assigned bus number 4
[   17.428013] ohci-platform fc8c0000.usb: irq 23, io mem 0xfc8c0000
[   17.483189] ata1: SATA link down (SStatus 0 SControl 300)
[   17.487411] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 5.10
[   17.487429] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   17.487439] usb usb4: Product: Generic Platform OHCI controller
[   17.487447] usb usb4: Manufacturer: Linux 5.10.160 ohci_hcd
[   17.487455] usb usb4: SerialNumber: fc8c0000.usb
[   17.487653] hub 4-0:1.0: USB hub found
[   17.487676] hub 4-0:1.0: 1 port detected
[   17.488257] xhci-hcd xhci-hcd.7.auto: xHCI Host Controller
[   17.488274] xhci-hcd xhci-hcd.7.auto: new USB bus registered, assigned bus number 5
[   17.488357] xhci-hcd xhci-hcd.7.auto: hcc params 0x0220fe64 hci version 0x110 quirks 0x0000200002010010
[   17.488387] xhci-hcd xhci-hcd.7.auto: irq 118, io mem 0xfcd00000
[   17.488539] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.10
[   17.488551] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   17.488560] usb usb5: Product: xHCI Host Controller
[   17.488568] usb usb5: Manufacturer: Linux 5.10.160 xhci-hcd
[   17.488575] usb usb5: SerialNumber: xhci-hcd.7.auto
[   17.488783] hub 5-0:1.0: USB hub found
[   17.488806] hub 5-0:1.0: 1 port detected
[   17.488955] xhci-hcd xhci-hcd.7.auto: xHCI Host Controller
[   17.488968] xhci-hcd xhci-hcd.7.auto: new USB bus registered, assigned bus number 6
[   17.488981] xhci-hcd xhci-hcd.7.auto: Host supports USB 3.0 SuperSpeed
[   17.489019] usb usb6: We don't know the algorithms for LPM for this host, disabling LPM.
[   17.489086] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.10
[   17.489098] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   17.489107] usb usb6: Product: xHCI Host Controller
[   17.489114] usb usb6: Manufacturer: Linux 5.10.160 xhci-hcd
[   17.489122] usb usb6: SerialNumber: xhci-hcd.7.auto
[   17.489316] hub 6-0:1.0: USB hub found
[   17.489338] hub 6-0:1.0: 1 port detected
[   17.489541] usbcore: registered new interface driver cdc_acm
[   17.489550] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[   17.489662] usbcore: registered new interface driver uas
[   17.489722] usbcore: registered new interface driver usb-storage
[   17.490334] Error: Driver 'Goodix-TS' is already registered, aborting...
[   17.490375] usbcore: registered new interface driver usbtouchscreen
[   17.491426] input: rk805 pwrkey as /devices/platform/feb20000.spi/spi_master/spi2/spi2.0/rk805-pwrkey.5.auto/input/input0
[   17.491695] i2c /dev entries driver
[   17.495283] vdd_cpu_big0_s0: supplied by vcc5v0_sys
[   17.503907] vdd_cpu_big1_s0: supplied by vcc5v0_sys
[   17.510431] Goodix-TS 2-0014: supply AVDD28 not found, using dummy regulator
[   17.510513] Goodix-TS 2-0014: supply VDDIO not found, using dummy regulator
[   17.603469] Goodix-TS 2-0014: i2c test failed attempt 1: -6
[   17.630129] Goodix-TS 2-0014: i2c test failed attempt 2: -6
[   17.656652] Goodix-TS 2-0014: I2C communication failure: -6
[   17.659796] vdd_npu_s0: supplied by vcc5v0_sys
[   17.697107] rtc-hym8563 6-0051: rtc information is invalid
[   17.703935] rtc-hym8563 6-0051: registered as rtc0
[   17.704952] rtc-hym8563 6-0051: setting system clock to 2021-01-01T12:00:00 UTC (1609502400)
[   17.707479] Goodix-TS 7-0014: supply AVDD28 not found, using dummy regulator
[   17.707570] Goodix-TS 7-0014: supply VDDIO not found, using dummy regulator
[   17.800144] Goodix-TS 7-0014: i2c test failed attempt 1: -6
[   17.826801] Goodix-TS 7-0014: i2c test failed attempt 2: -6
[   17.853318] Goodix-TS 7-0014: I2C communication failure: -6
[   17.854271] rkcifhw fdce0000.rkcif: Adding to iommu group 16
[   17.854629] rkcifhw fdce0000.rkcif: No reserved memory region assign to CIF
[   17.855753] rkisp_hw fdcb0000.rkisp: Adding to iommu group 14
[   17.855874] rkisp_hw fdcb0000.rkisp: is_thunderboot: 0
[   17.855884] rkisp_hw fdcb0000.rkisp: max input:0x0@0fps
[   17.855893] rkisp_hw fdcb0000.rkisp: Missing rockchip,grf property
[   17.855994] rkisp_hw fdcb0000.rkisp: no find phandle sram
[   17.856068] rkisp_hw fdcc0000.rkisp: Adding to iommu group 15
[   17.856220] rkisp_hw fdcc0000.rkisp: is_thunderboot: 0
[   17.856230] rkisp_hw fdcc0000.rkisp: max input:0x0@0fps
[   17.856238] rkisp_hw fdcc0000.rkisp: Missing rockchip,grf property
[   17.856332] rkisp_hw fdcc0000.rkisp: no find phandle sram
[   17.857281] usbcore: registered new interface driver uvcvideo
[   17.857291] USB Video Class driver (1.1.1)
[   17.859161] cpu cpu0: bin=0
[   17.859342] cpu cpu0: leakage=10
[   17.860802] cpu cpu0: pvtm=1443
[   17.860947] cpu cpu0: pvtm-volt-sel=2
[   17.862956] cpu cpu4: bin=0
[   17.863138] cpu cpu4: leakage=8
[   17.869677] cpu cpu4: pvtm=1684
[   17.873646] cpu cpu4: pvtm-volt-sel=4
[   17.876388] cpu cpu6: bin=0
[   17.876570] cpu cpu6: leakage=8
[   17.883077] cpu cpu6: pvtm=1687
[   17.887038] cpu cpu6: pvtm-volt-sel=4
[   17.888710] cpu cpu0: avs=0
[   17.889446] cpu cpu4: avs=0
[   17.890180] cpu cpu6: avs=0
[   17.890437] cpu cpu0: EM: created perf domain
[   17.890480] cpu cpu0: l=10000 h=85000 hyst=5000 l_limit=0 h_limit=1608000000 h_table=0
[   17.891286] cpu cpu4: EM: created perf domain
[   17.891324] cpu cpu4: l=10000 h=85000 hyst=5000 l_limit=0 h_limit=2208000000 h_table=0
[   17.900042] cpu cpu6: EM: created perf domain
[   17.900497] cpu cpu6: l=10000 h=85000 hyst=5000 l_limit=0 h_limit=2208000000 h_table=0
[   17.915380] sdhci: Secure Digital Host Controller Interface driver
[   17.915429] sdhci: Copyright(c) Pierre Ossman
[   17.915449] Synopsys Designware Multimedia Card Interface Driver
[   17.916618] sdhci-pltfm: SDHCI platform and OF driver helper
[   17.921129] ledtrig-cpu: registered to indicate activity on CPUs
[   17.921225] arm-scmi firmware:scmi: Failed. SCMI protocol 17 not active.
[   17.921329] SMCCC: SOC_ID: ARCH_SOC_ID not implemented, skipping ....
[   17.922767] cryptodev: driver 1.12 loaded.
[   17.922842] hid: raw HID events driver (C) Jiri Kosina
[   17.923109] usbcore: registered new interface driver usbhid
[   17.923131] usbhid: USB HID core driver
[   17.930436] optee: probing for conduit method.
[   17.930469] optee: api uid mismatch
[   17.930491] optee: probe of firmware:optee failed with error -22
[   17.931278] usbcore: registered new interface driver snd-usb-audio
[   17.942790] debugfs: File 'Capture' in directory 'dapm' already present!
[   17.944366] input: rockchip-dp0 rockchip-dp0 as /devices/platform/dp0-sound/sound/card0/input1
[   17.946363] input: rockchip-hdmi0 rockchip-hdmi0 as /devices/platform/hdmi0-sound/sound/card1/input2
[   17.948108] input: headset-keys as /devices/platform/es8388-sound/input/input3
[   17.959722] ES8323 6-0010: ASoC: error at soc_component_write_no_lock on ES8323.6-0010: -5
[   18.017172] input: rockchip-es8388 Headset as /devices/platform/es8388-sound/sound/card2/input4
[   18.018033] Initializing XFRM netlink socket
[   18.018056] NET: Registered protocol family 17
[   18.018360] [BT_RFKILL]: Enter rfkill_rk_init
[   18.018373] [WLAN_RFKILL]: Enter rfkill_wlan_init
[   18.018790] Key type dns_resolver registered
[   18.020086] registered taskstats version 1
[   18.020102] Loading compiled-in X.509 certificates
[   18.020864] Btrfs loaded, crc32c=crc32c-generic
[   18.020977] pstore: Using crash dump compression: deflate
[   18.021184] rga3_core0 fdb60000.rga: Adding to iommu group 2
[   18.021376] rga: rga3_core0, irq = 35, match scheduler
[   18.021740] rga: rga3_core0 hardware loaded successfully, hw_version:3.0.76831.
[   18.021773] rga: rga3_core0 probe successfully
[   18.022079] rga3_core1 fdb70000.rga: Adding to iommu group 3
[   18.022255] rga: rga3_core1, irq = 36, match scheduler
[   18.022568] rga: rga3_core1 hardware loaded successfully, hw_version:3.0.76831.
[   18.022597] rga: rga3_core1 probe successfully
[   18.022932] rga: rga2, irq = 37, match scheduler
[   18.023243] rga: rga2 hardware loaded successfully, hw_version:3.2.63318.
[   18.023262] rga: rga2 probe successfully
[   18.023481] rga_iommu: IOMMU binding successfully, default mapping core[0x1]
[   18.023695] rga: Module initialized. v1.2.25
[   18.066044] mali fb000000.gpu: Kernel DDK version g17p0-01eac0
[   18.066137] combophy_avdd0v85: supplied by vdd_0v85_s0
[   18.067156] mali fb000000.gpu: bin=0
[   18.067254] combophy_avdd1v8: supplied by avcc_1v8_s0
[   18.067420] mali fb000000.gpu: leakage=15
[   18.067493] debugfs: Directory 'fb000000.gpu-mali' with parent 'vdd_gpu_s0' already present!
[   18.068131] vcc_3v3_sd_s0: supplied by vcc_3v3_s3
[   18.069028] mali fb000000.gpu: pvtm=870
[   18.069242] mali fb000000.gpu: pvtm-volt-sel=3
[   18.070368] mali fb000000.gpu: avs=0
[   18.070680] rockchip-dmc dmc: leakage=33
[   18.070714] rockchip-dmc dmc: leakage-volt-sel=1
[   18.071364] rockchip-dmc dmc: avs=0
[   18.071400] rockchip-dmc dmc: current ATF version 0x100
[   18.071576] rockchip-dmc dmc: normal_rate = 1560000000
[   18.071598] rockchip-dmc dmc: reboot_rate = 2112000000
[   18.071618] rockchip-dmc dmc: suspend_rate = 528000000
[   18.071638] rockchip-dmc dmc: video_4k_rate = 1560000000
[   18.071657] rockchip-dmc dmc: video_4k_10b_rate = 1560000000
[   18.071678] rockchip-dmc dmc: video_svep_rate = 1560000000
[   18.071697] rockchip-dmc dmc: boost_rate = 2112000000
[   18.071717] rockchip-dmc dmc: fixed_rate(isp|cif0|cif1|dualview) = 2112000000
[   18.071738] rockchip-dmc dmc: performance_rate = 2112000000
[   18.071759] rockchip-dmc dmc: hdmirx_rate = 2112000000
[   18.071786] rockchip-dmc dmc: failed to get vop bandwidth to dmc rate
[   18.071806] rockchip-dmc dmc: failed to get vop pn to msch rl
[   18.072027] rockchip-dmc dmc: l=10000 h=2147483647 hyst=5000 l_limit=0 h_limit=0 h_table=0
[   18.072120] rockchip-dmc dmc: could not find power_model node
[   18.073020] W : [File] : drivers/gpu/arm/bifrost/platform/rk/mali_kbase_config_rk.c; [Line] : 143; [Func] : kbase_platform_rk_init(); power-off-delay-ms not available.
[   18.073561] input: adc-keys as /devices/platform/adc-keys/input/input5
[   18.073829] mali fb000000.gpu: GPU hardware issue table may need updating:
[   18.073829] r0p0 status 5 is unknown; treating as r0p0 status 0
[   18.073866] mali fb000000.gpu: GPU identified as 0x7 arch 10.8.6 r0p0 status 0
[   18.073943] mali fb000000.gpu: No priority control manager is configured
[   18.074292] mali fb000000.gpu: No memory group manager is configured
[   18.074337] mali fb000000.gpu: Protected memory allocator not available
[   18.075293] mali fb000000.gpu: Capping CSF_FIRMWARE_TIMEOUT to CSF_FIRMWARE_PING_TIMEOUT
[   18.076589] mali fb000000.gpu: Couldn't find power_model DT node matching 'arm,mali-simple-power-model'
[   18.076615] mali fb000000.gpu: Error -22, no DT entry: mali-simple-power-model.static-coefficient = 1*[0]
[   18.076874] mali fb000000.gpu: Error -22, no DT entry: mali-simple-power-model.dynamic-coefficient = 1*[0]
[   18.077114] mali fb000000.gpu: Error -22, no DT entry: mali-simple-power-model.ts = 4*[0]
[   18.077345] mali fb000000.gpu: Error -22, no DT entry: mali-simple-power-model.thermal-zone = ''
[   18.077579] dwmmc_rockchip fe2c0000.mmc: IDMAC supports 32-bit address mode.
[   18.077615] dwmmc_rockchip fe2c0000.mmc: Using internal DMA controller.
[   18.077634] dwmmc_rockchip fe2c0000.mmc: Version ID is 270a
[   18.077676] dwmmc_rockchip fe2c0000.mmc: DW MMC controller at irq 86,32 bit host data width,256 deep fifo
[   18.080829] mali fb000000.gpu: Using configured power model mali-lodx-power-model, and fallback mali-simple-power-model
[   18.080999] mali fb000000.gpu: l=10000 h=85000 hyst=5000 l_limit=0 h_limit=800000000 h_table=0
[   18.081696] RKNPU fdab0000.npu: Adding to iommu group 0
[   18.081848] RKNPU fdab0000.npu: RKNPU: rknpu iommu is enabled, using iommu mode
[   18.082354] mali fb000000.gpu: Probed as mali0
[   18.083166] RKNPU fdab0000.npu: can't request region for resource [mem 0xfdab0000-0xfdabffff]
[   18.083194] RKNPU fdab0000.npu: can't request region for resource [mem 0xfdac0000-0xfdacffff]
[   18.083217] RKNPU fdab0000.npu: can't request region for resource [mem 0xfdad0000-0xfdadffff]
[   18.083486] [drm] Initialized rknpu 0.8.5 20230202 for fdab0000.npu on minor 1
[   18.087844] RKNPU fdab0000.npu: RKNPU: bin=0
[   18.088041] RKNPU fdab0000.npu: leakage=8
[   18.088129] debugfs: Directory 'fdab0000.npu-rknpu' with parent 'vdd_npu_s0' already present!
[   18.095100] mmc_host mmc1: Bus speed (slot 0) = 400000Hz (slot req 400000Hz, actual 400000HZ div = 0)
[   18.096008] RKNPU fdab0000.npu: pvtm=866
[   18.101358] RKNPU fdab0000.npu: pvtm-volt-sel=3
[   18.102228] RKNPU fdab0000.npu: avs=0
[   18.102422] RKNPU fdab0000.npu: l=10000 h=85000 hyst=5000 l_limit=0 h_limit=800000000 h_table=0
[   18.114257] RKNPU fdab0000.npu: failed to find power_model node
[   18.114320] RKNPU fdab0000.npu: RKNPU: failed to initialize power model
[   18.114343] RKNPU fdab0000.npu: RKNPU: failed to get dynamic-coefficient
[   18.115639] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[   18.118589] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[   18.118801] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[   18.118832] cfg80211: failed to load regulatory.db
[   18.120326] rockchip-pm rockchip-suspend: not set pwm-regulator-config
[   18.120367] rockchip-suspend not set sleep-mode-config for mem-lite
[   18.120386] rockchip-suspend not set wakeup-config for mem-lite
[   18.120409] rockchip-suspend not set sleep-mode-config for mem-ultra
[   18.120428] rockchip-suspend not set wakeup-config for mem-ultra
[   18.122173] I : [File] : drivers/gpu/arm/mali400/mali/linux/mali_kernel_linux.c; [Line] : 406; [Func] : mali_module_init(); svn_rev_string_from_arm of this mali_ko is '', rk_ko_ver is '5', built at '00:00:00.
[   18.122726] Mali: 
[   18.122731] Mali device driver loaded
[   18.122760] ALSA device list:
[   18.122776]   #0: rockchip-dp0
[   18.122791]   #1: rockchip-hdmi0
[   18.122806]   #2: rockchip-es8388
[   18.131691] Freeing unused kernel memory: 7040K
[   18.147093] Run /init as init process
[   18.153172] mmc_host mmc1: Bus speed (slot 0) = 148500000Hz (slot req 150000000Hz, actual 148500000HZ div = 0)
[   18.163080] dwmmc_rockchip fe2c0000.mmc: Successfully tuned phase to 135
[   18.163126] mmc1: new ultra high speed SDR104 SDXC card at address 59b4
[   18.164523] mmcblk1: mmc1:59b4 FD4Q5 119 GiB 
[   18.167005]  mmcblk1: p1 p2
[   18.521622] rk_gmac-dwmac fe1c0000.ethernet end1: renamed from eth0
[   18.808828] EXT4-fs (mmcblk1p2): mounted filesystem with ordered data mode. Opts: (null)
[   18.811499] EXT4-fs (mmcblk1p2): re-mounted. Opts: (null)
[   19.936603] EXT4-fs (mmcblk1p2): re-mounted. Opts: (null)
[   19.939633] booting system configuration /nix/store/2amdg4d4nzr6r0m7sqk77fchmkldw1pv-nixos-system-orangepi5-23.05pre-git
[   21.023368] vendor storage:20190527 ret = -1
[   21.782694] systemd[1]: System time before build time, advancing clock.
[   21.869948] NET: Registered protocol family 10
[   21.871630] Segment Routing with IPv6
[   21.902326] systemd[1]: systemd 253.6 running in system mode (+PAM +AUDIT -SELINUX +APPARMOR +IMA +SMACK +SECCOMP +GCRYPT -GNUTLS +OPENSSL +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN +IPTC +KMOD +LIBCRYPTS)
[   21.902389] systemd[1]: Detected architecture arm64.
[   22.107926] systemd[1]: bpf-lsm: BPF LSM hook not enabled in the kernel, BPF LSM not supported
[   22.612257] systemd[1]: Queued start job for default target Multi-User System.
[   22.621205] systemd[1]: Created slice Slice /system/getty.
[   22.623640] systemd[1]: Created slice Slice /system/modprobe.
[   22.625858] systemd[1]: Created slice Slice /system/serial-getty.
[   22.627812] systemd[1]: Created slice User and Session Slice.
[   22.628316] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[   22.628757] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[   22.629066] systemd[1]: Reached target Local Encrypted Volumes.
[   22.629329] systemd[1]: Reached target Containers.
[   22.629688] systemd[1]: Reached target Path Units.
[   22.629917] systemd[1]: Reached target Remote File Systems.
[   22.630149] systemd[1]: Reached target Slice Units.
[   22.630389] systemd[1]: Reached target Swaps.
[   22.635650] systemd[1]: Listening on Process Core Dump Socket.
[   22.636259] systemd[1]: Listening on Journal Socket (/dev/log).
[   22.636878] systemd[1]: Listening on Journal Socket.
[   22.637530] systemd[1]: Listening on Userspace Out-Of-Memory (OOM) Killer Socket.
[   22.638567] systemd[1]: Listening on udev Control Socket.
[   22.639056] systemd[1]: Listening on udev Kernel Socket.
[   22.642836] systemd[1]: Mounting Huge Pages File System...
[   22.646182] systemd[1]: Mounting POSIX Message Queue File System...
[   22.650046] systemd[1]: Mounting Kernel Debug File System...
[   22.654623] systemd[1]: Starting Create List of Static Device Nodes...
[   22.659203] systemd[1]: Starting Load Kernel Module configfs...
[   22.662245] systemd[1]: Starting Load Kernel Module drm...
[   22.665254] systemd[1]: Starting Load Kernel Module efi_pstore...
[   22.668224] systemd[1]: Starting Load Kernel Module fuse...
[   22.671040] systemd[1]: Starting mount-pstore.service...
[   22.671397] systemd[1]: File System Check on Root Device was skipped because of an unmet condition check (ConditionPathIsReadWrite=!/).
[   22.674881] systemd[1]: Starting Journal Service...
[   22.677734] systemd[1]: Starting Load Kernel Modules...
[   22.680244] systemd[1]: Starting Remount Root and Kernel File Systems...
[   22.683013] systemd[1]: Starting Coldplug All udev Devices...
[   22.687858] systemd[1]: Mounted Huge Pages File System.
[   22.688322] systemd[1]: Mounted POSIX Message Queue File System.
[   22.688587] systemd[1]: Mounted Kernel Debug File System.
[   22.689160] systemd[1]: Finished Create List of Static Device Nodes.
[   22.689899] systemd[1]: modprobe@configfs.service: Deactivated successfully.
[   22.690308] systemd[1]: Finished Load Kernel Module configfs.
[   22.690943] systemd[1]: modprobe@drm.service: Deactivated successfully.
[   22.691246] systemd[1]: Finished Load Kernel Module drm.
[   22.691891] systemd[1]: modprobe@efi_pstore.service: Deactivated successfully.
[   22.692196] systemd[1]: Finished Load Kernel Module efi_pstore.
[   22.692568] fuse: init (API version 7.32)
[   22.695115] systemd[1]: modprobe@fuse.service: Deactivated successfully.
[   22.695532] systemd[1]: Finished Load Kernel Module fuse.
[   22.699233] systemd[1]: Mounting FUSE Control File System...
[   22.701840] systemd[1]: Mounting Kernel Configuration File System...
[   22.704301] systemd[1]: Starting Create Static Device Nodes in /dev...
[   22.704652] systemd-journald[704]: Collecting audit messages is disabled.
[   22.709329] systemd[1]: Mounted FUSE Control File System.
[   22.709703] systemd[1]: Mounted Kernel Configuration File System.
[   22.727484] EXT4-fs (mmcblk1p2): re-mounted. Opts: (null)
[   22.731184] systemd[1]: Finished Remount Root and Kernel File Systems.
[   22.733107] systemd[1]: Finished Create Static Device Nodes in /dev.
[   22.733981] systemd[1]: Finished mount-pstore.service.
[   22.734202] systemd[1]: Reached target Preparation for Local File Systems.
[   22.734267] systemd[1]: Reached target Local File Systems.
[   22.734409] systemd[1]: Platform Persistent Storage Archival was skipped because of an unmet condition check (ConditionDirectoryNotEmpty=/sys/fs/pstore).
[   22.736601] systemd[1]: Starting Load/Save OS Random Seed...
[   22.738544] systemd[1]: Starting Rule-based Manager for Device Events and Files...
[   22.739186] bridge: filtering via arp/ip/ip6tables is no longer available by default. Update your scripts to load br_netfilter if you need this.
[   22.756614] tun: Universal TUN/TAP device driver, 1.6
[   22.760100] systemd[1]: Finished Load Kernel Modules.
[   22.763278] systemd[1]: Starting Firewall...
[   22.766156] systemd[1]: Starting Apply Kernel Variables...
[   22.791254] systemd[1]: Started Journal Service.
[   22.819344] systemd-journald[704]: Received client request to flush runtime journal.
[   22.823696] systemd-journald[704]: File /var/log/journal/3819d6f55bbb4cf997c03bf1277b8326/system.journal corrupted or uncleanly shut down, renaming and replacing.
[   23.204086] 8021q: 802.1Q VLAN Support v1.8
[   23.290754] rk_gmac-dwmac fe1c0000.ethernet end1: PHY [stmmac-1:01] driver [YT8531 Gigabit Ethernet] (irq=POLL)
[   23.293332] dwmac4: Master AXI performs any burst length
[   23.293371] rk_gmac-dwmac fe1c0000.ethernet end1: No Safety Features support found
[   23.293397] rk_gmac-dwmac fe1c0000.ethernet end1: IEEE 1588-2008 Advanced Timestamp supported
[   23.293589] rk_gmac-dwmac fe1c0000.ethernet end1: registered PTP clock
[   23.293955] rk_gmac-dwmac fe1c0000.ethernet end1: configuring for phy/rgmii-rxid link mode
[   23.294474] 8021q: adding VLAN 0 to HW filter on device end1
[   28.628593] ttyFIQ ttyFIQ0: tty_port_close_start: tty->count = 1 port count = 2


<<< Welcome to NixOS 23.05pre-git (aarch64) - ttyFIQ0 >>>

Run 'nixos-help' for the NixOS manual.

orangepi5 login: 
```
