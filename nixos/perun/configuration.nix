# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ../common
    ../common/docker.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "perun"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.xserver = {
    videoDrivers = [ "modeset" "nvidia" ];
  };

   users.users.kruppenfield = {
    extraGroups = [ "docker" "networkmanager" "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    docker-compose  
  ];

  hardware.nvidia = {
    powerManagement.enable = true;
    modesetting.enable = true;
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
    };
  };

}
