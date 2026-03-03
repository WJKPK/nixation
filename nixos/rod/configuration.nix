{
  pkgs,
  inputs,
  outputs,
  color-scheme,
  ...
}: {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./home-assistant.nix
    ./adguard.nix
    ./immich.nix
    ./syncthing.nix
    ./nix-serve.nix
    ./distributed-builds.nix
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs color-scheme;};
    users.kruppenfield.imports = [
      ../../home-manager/rod.nix
      inputs.noctalia.homeModules.default
    ];
  };

  users.groups.admin = {};
  users.users.kruppenfield = {
    isNormalUser = true;
    extraGroups = ["docker" "networkmanager" "wheel" "libvirtd"];
    group = "admin";
  };

  networking = {
    hostName = "rod";
    firewall.allowedTCPPorts = [22];
  };

  graphicalEnvironment = {
    enable = false;
  };
  nvidiaManagement = {
    driver.enable = false;
  };

  rod = {
    services = {
      adguard.enable = true;
      homeAssistant.enable = true;
      immich.enable = true;
      syncthing.enable = true;
      nixServe.enable = true;
    };
    distributedBuilds.enable = true;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_6_12;
    swraid.enable = true;
    initrd.supportedFilesystems = ["xfs"];
  };

  environment = {
    sessionVariables = {LIBVA_DRIVER_NAME = "iHD";};
    systemPackages = with pkgs; [
      mdadm
      docker-compose
    ];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
