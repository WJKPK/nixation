{ pkgs, lib, inputs, outputs, ... }: {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./virt-manager.nix
    ./docker.nix
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs;};
    users.kruppenfield = import ../../home-manager/perun.nix;
  };

  nix.settings = {
    substituters = [ "https://cuda-maintainers.cachix.org"
                     "https://hyprland.cachix.org"
                     ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  users.users.kruppenfield = {
    extraGroups = [ "docker" "networkmanager" "wheel" "libvirtd" ];
  };

  networking = {
    hostName = "perun";
    dhcpcd.denyInterfaces = [ "macvtap*" ];
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

  specialisation."ML-spec".configuration = {
    system.nixos.tags = [ "ML-spec" ];
    nvidiaManagement.vfio.enable = lib.mkForce false;
  };

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    acceleration = "cuda";
  };

  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    docker-compose  
  ];

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
}
