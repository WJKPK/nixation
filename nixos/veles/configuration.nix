{ pkgs, inputs, outputs, lib, ... }:
  {
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
    ../common
    ./hardware-configuration.nix
    ./distributed-builds.nix
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs;};
    users.kruppenfield = import ../../home-manager/veles.nix;
  };

  nvidiaManagement.driver.enable = false;
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  specialisation."GPU-enable".configuration = {
    system.nixos.tags = [ "GPU-enable" ];
    nvidiaManagement = {
        driver.enable = lib.mkForce true;
        optimus = {
          enable = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
    };
  };
  graphicalEnvironment = {
      enable = true;
      compositor = {
        enable = true;
        type = "hyprland";
      };
  };
  wirelessSettings = {
    bluetooth.enable = true;
    subGhzAdapter.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  networking = {
    hostName = "veles";
    wg-quick.interfaces.veles = {
      configFile = "/etc/wireguard/veles.conf";
    };
    firewall = {
        allowedUDPPorts = [ 51820 52810 ];
        checkReversePath = false;
    };
  };

  services = {
    libinput = {
      enable = true;
      touchpad = {
        scrollMethod = "twofinger";
      };
    };
    logind = {
      lidSwitch = "hibernate";
      powerKey = "poweroff";
      extraConfig = ''
        IdleAction=suspend
        IdleActionSec=2m
      '';
    };
    tlp = {
      enable = true;
      settings = {
        DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE="bluetooth";
        DEVICES_TO_DISABLE_ON_LAN_CONNECT="wifi wwan";
        DEVICES_TO_DISABLE_ON_WIFI_CONNECT="wwan";

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balence_power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        PLATFORM_PROFILE_ON_AC = "balanced";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        CPU_BOOST_ON_AC=1;
        CPU_BOOST_ON_BAT=0;
        CPU_HWP_DYN_BOOST_ON_AC=1;
        CPU_HWP_DYN_BOOST_ON_BAT=0;
      };
    };
  };

  security.protectKernelImage = false;
  boot.resumeDevice = "/dev/disk/by-uuid/54bf766e-32b7-42c6-8c01-58238bf6219b";
  #filefrag -v /var/lib/swapfile| awk '{ if($1=="0:"){print $4} }
  boot.kernelParams = ["resume_offset=54437888" "mitigations=off"];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
