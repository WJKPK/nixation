{ config, lib, pkgs, modulesPath, ... }: {
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/47889761-1424-46d3-abb6-aa1a5718b6df";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/F2C1-10C7";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/md0" =
    { device = "/dev/disk/by-uuid/8e7b1b46-ae55-46c3-ace2-51cd218603e4";
      fsType = "xfs";
      neededForBoot = false;
    };

  fileSystems."/vms" =
    { device = "/dev/disk/by-uuid/4d376007-d1bd-4ace-8277-337f172a83d5";
      fsType = "btrfs";
      neededForBoot = false;
    };

   swapDevices =
    [ { device = "/dev/disk/by-uuid/68f30e33-2863-4033-80c4-01d85f6414ec"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
