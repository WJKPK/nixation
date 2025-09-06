{ pkgs, lib, inputs, outputs, ... }: {
  imports = [
    ../common
    ./virtualization
    ./hardware-configuration.nix
    ./remote-build/remote-builder.nix
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs;};
    users.kruppenfield = import ../../home-manager/perun.nix;
  };

  users.users.kruppenfield = {
    extraGroups = [ "docker" "networkmanager" "wheel" "libvirtd" ];
  };

  networking = {
    hostName = "perun";
    dhcpcd.denyInterfaces = [ "macvtap*" ];
    firewall.allowedTCPPorts = [ 22 ];
  };

  boot.kernelPackages = pkgs.linuxPackages_6_12;

  nvidiaManagement = {
      driver.enable = true;
      vfio = {
      enable = true;
      gpuIDs = [
        "10de:1b81" # GTX 1070 Graphics
        "10de:10f0" # GTX 1070 Audio
      ];
    };
  };
  nvidia-undervolt.enable = true;
  graphicalEnvironment = {
      enable = true;
      compositor = {
        enable = true;
        type = "hyprland";
      };
  };
  monitors = [
    {
      name = "DP-1";
      width = 3440;
      height = 1440;
      x = 0;
      workspace = "1";
      scale = 1.0;
      refreshRate = 165; 
      enabled = true;
      primary = true;
    }
  ];
  wirelessSettings = {
    bluetooth.enable = true;
    subGhzAdapter.enable = true;
  };

  specialisation."ML-spec".configuration = {
    system.nixos.tags = [ "ML-spec" ];
    nvidiaManagement.vfio.enable = lib.mkForce false;
    nvidia-undervolt.enable = lib.mkForce true;
  };
  aiLocal.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    docker-compose  
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
