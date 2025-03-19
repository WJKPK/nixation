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

  nvidia-undervolt.enable = true;

  graphicalEnvironment = {
      enable = true;
      compositor = {
        enable = true;
        type = "hyprland";
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      };
  };

  specialisation."ML-spec".configuration = {
    system.nixos.tags = [ "ML-spec" ];
    nvidiaManagement.vfio.enable = lib.mkForce false;
    nvidia-undervolt.enable = lib.mkForce true;
  };

  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      acceleration = "cuda";
    };
    open-webui = {
      enable = true;
      port = 8085;
      package = pkgs.stable.open-webui;
    };
  };

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
