{ pkgs, inputs, outputs, ... }: {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./home-assistant.nix
    ./adguard.nix
    ./immich.nix
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users.kruppenfield = import ../../home-manager/rod.nix;
  };
  users.groups.admin = {};
  users.users.kruppenfield = {
    isNormalUser = true;
    extraGroups = [ "docker" "networkmanager" "wheel" "libvirtd" ];
    group = "admin";
  };

  networking.hostName = "rod";

  graphicalEnvironment = {
      enable = false;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };
  users.users.immich.extraGroups = [ "video" "render" ];

  boot = {
    kernelPackages = pkgs.linuxPackages_6_12;
    swraid.enable = true;
    initrd.supportedFilesystems = [ "xfs" ];
  };

  nvidiaManagement = {
      driver.enable = false;
  };

  environment.systemPackages = with pkgs; [
    mdadm
    docker-compose  
  ];

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 3;
      graphics = false;
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
