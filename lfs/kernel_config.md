# Kernel settings

## General
```
General setup --->
  [ ] Compile the kernel with warnings as errors                        [WERROR]
  CPU/Task time and stats accounting --->
    [*] Pressure stall information tracking                                [PSI]
    [ ]   Require boot parameter to enable pressure stall information tracking
                                                     ...  [PSI_DEFAULT_DISABLED]
  < > Enable kernel headers through /sys/kernel/kheaders.tar.xz      [IKHEADERS]
  [*] Control Group support --->                                       [CGROUPS]
    [*] Memory controller                                                [MEMCG]
  [ ] Configure standard kernel features (expert users) --->            [EXPERT]

Processor type and features --->
  [*] Build a relocatable kernel                                   [RELOCATABLE]
  [*]   Randomize the address of the kernel image (KASLR)       [RANDOMIZE_BASE]

General architecture-dependent options --->
  [*] Stack Protector buffer overflow detection                 [STACKPROTECTOR]
  [*]   Strong Stack Protector                           [STACKPROTECTOR_STRONG]

Device Drivers --->
  Generic Driver Options --->
    [ ] Support for uevent helper                                [UEVENT_HELPER]
    [*] Maintain a devtmpfs filesystem to mount at /dev               [DEVTMPFS]
    [*]   Automount devtmpfs at /dev, after the kernel mounted the rootfs
                                                           ...  [DEVTMPFS_MOUNT]
  Firmware Drivers --->
    [*] Mark VGA/VBE/EFI FB as generic system framebuffer       [SYSFB_SIMPLEFB]
  Graphics support --->
    <*>    Direct Rendering Manager (XFree86 4.1.0 and higher DRI support) --->
                                                                      ...  [DRM]
    [*]    Display a user-friendly message when a kernel panic occurs
                                                                ...  [DRM_PANIC]
    (kmsg)   Panic screen formatter                           [DRM_PANIC_SCREEN]
    Supported DRM clients --->
      [*] Enable legacy fbdev support for your modesetting driver
                                                      ...  [DRM_FBDEV_EMULATION]
    Drivers for system framebuffers --->
      <*> Simple framebuffer driver                              [DRM_SIMPLEDRM]
    Console display driver support --->
      [*] Framebuffer Console support                      [FRAMEBUFFER_CONSOLE]
```

## 64 bit systems
```
Processor type and features --->
  [*] x2APIC interrupt controller architecture support              [X86_X2APIC]

Device Drivers --->
  [*] PCI support --->                                                     [PCI]
    [*] Message Signaled Interrupts (MSI and MSI-X)                    [PCI_MSI]
  [*] IOMMU Hardware Support --->                                [IOMMU_SUPPORT]
    [*] Support for Interrupt Remapping                              [IRQ_REMAP]
```

## NVME Support
```
Device Drivers --->
  NVME Support --->
    <*> NVM Express block device                                  [BLK_DEV_NVME]
```

## Kernel Configuration for UEFI support 
```
Processor type and features --->
  [*] EFI runtime service support                                          [EFI]
  [*]   EFI stub support                                              [EFI_STUB]

-*- Enable the block layer --->                                          [BLOCK]
  Partition Types --->
    [ /*] Advanced partition selection                      [PARTITION_ADVANCED]
    [*]     EFI GUID Partition support                           [EFI_PARTITION]

File systems --->
  DOS/FAT/EXFAT/NT Filesystems --->
    <*/M> VFAT (Windows-95) fs support                                 [VFAT_FS]
  Pseudo filesystems --->
    <*/M> EFI Variable filesystem                                    [EFIVAR_FS]
  -*- Native language support --->                                         [NLS]
    <*/M> Codepage 437 (United States, Canada)                [NLS_CODEPAGE_437]
    <*/M> NLS ISO 8859-1  (Latin 1; Western European Languages)  [NLS_ISO8859_1]
```