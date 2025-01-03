{ config, lib, modulesPath, ... }: {
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/e8b2f335-8820-4033-b553-2f0e11d82fa5";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/F024-80DF";
      fsType = "vfat";
    };

  fileSystems."/multimedia" =
    { device = "/dev/disk/by-uuid/654c816d-34b1-4b55-b447-8ccb61ee51ca";
      fsType = "ext4";
      options = [ "rw" ];
    };

  fileSystems."/vms" =
    { device = "/dev/disk/by-uuid/9e7d7537-26e4-472c-b0a7-c5c1afef0388";
      fsType = "ext4";
      options = [ "rw" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/aeb310fe-0e02-4c59-ba1c-6036aa5a2be6"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
