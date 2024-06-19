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
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" ];
  };

  hardware.nvidia = {
    powerManagement.enable = true;
    modesetting.enable = true;
    #open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "555.42.02";
      sha256_64bit = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
      sha256_aarch64 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
      openSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
      settingsSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA="; 
      persistencedSha256 = "sha256-3ae31/egyMKpqtGEqgtikWcwMwfcqMv2K4MVFa70Bqs=";
    };
  };

  environment = {
    sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDER_ALLOW_SOFTWARE = "1";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_CURRENT_TYPE = "Hyprland";

      NIXOS_OZONE_WL = "1";
    };
  };

  nix.settings = {
    substituters = [ "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
  specialisation."ML-spec".configuration = {
    system.nixos.tags = [ "ML-spec" ];
    vfio.enable = false;
  };
}
