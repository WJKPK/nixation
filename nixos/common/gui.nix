{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf mkMerge;

  compositorModules = type: {
      hyprland = {
        programs.hyprland = {
          enable = true;
          withUWSM = true;
          package = pkgs.hyprland;
          xwayland.enable = true;
        };
        services.hypridle.enable = true;
        security.pam.services.hyprlock = {};
      };
      cosmic = {
        services.desktopManager.cosmic.enable = true;
      };
    }.${type} or {};
in
{
  options.graphicalEnvironment = {
    enable = mkEnableOption "Enable graphical environment configuration";
    compositor = {
      enable = mkEnableOption "Enable compositor configuration";
      type = mkOption {
        type = types.enum [ "hyprland" "cosmic" ];
        default = "hyprland";
        description = "The compositor / desktop environment to use.";
      };
    };
  };

  config = let 
     cfg = config.graphicalEnvironment;
     #nvidia-cfg = config.nvidiaManagement;
  in mkMerge [
    (mkIf cfg.enable {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = "${import ./sddm-theme.nix { inherit pkgs; }}";
      };

      services.gvfs.enable = true;
      environment.systemPackages = with pkgs; [
        gparted
        hyprpolkitagent
        libsForQt5.qt5.qtquickcontrols2
        libsForQt5.qt5.qtgraphicaleffects
      ];

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
        ];
      };

      security = {
        rtkit.enable = true;
        polkit.enable = true;
      };

      assertions = [
        {
          assertion = cfg.compositor.enable -> cfg.compositor.type != null;
          message = "If compositor is enabled, a type must be specified.";
        }
      ];
    })
    (mkIf (cfg.enable && cfg.compositor.enable) (compositorModules cfg.compositor.type))
   ];
}
