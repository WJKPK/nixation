{ pkgs, config, lib, ... }: {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./gpu_isolate.nix
    ./virt-manager.nix
    ./docker.nix
  ];

  networking = {
    hostName = "perun";
    dhcpcd.denyInterfaces = [ "macvtap*" ];
  };

  powerManagement.enable = true;
  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };
  users.users.kruppenfield = {
    extraGroups = [ "docker" "networkmanager" "wheel" "libvirtd" ];
  };

  environment.systemPackages = with pkgs; [
    docker-compose  
  ];

  programs.steam.enable = true;

  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [ "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
  };

  hardware.nvidia = {
    powerManagement.enable = true;
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment = {
    sessionVariables = {
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE= "wayland";

      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = 0;
    };
  };

  nix.settings = {
    substituters = [ "https://cuda-maintainers.cachix.org"
                     "https://hyprland.cachix.org"
                     "https://marcus7070.cachix.org"
                     ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "marcus7070.cachix.org-1:JawxHSgnYsgNYJmNqZwvLjI4NcOwrcEZDToWlT3WwXw="
    ];
  };
  specialisation."ML-spec".configuration = {
    system.nixos.tags = [ "ML-spec" ];
    vfio.enable = false;
  };
}
