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
    initialPassword = "admin";
    group = "admin";
  };

  networking.hostName = "rod";

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };
  users.users.immich.extraGroups = [ "video" "render" ];
  boot.kernelPackages = pkgs.linuxPackages;
  nvidiaManagement = {
      driver.enable = false;
  };

  environment.systemPackages = with pkgs; [
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
}
