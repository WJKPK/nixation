{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf types mkOption;
  cfg = config.graphicalEnvironment;
in {
  options.graphicalEnvironment = {
    enable = mkEnableOption "Enable graphical environment configuration";

    compositor = {
      enable = mkEnableOption "Enable compositor configuration";

      type = mkOption {
        type = types.enum [ "hyprland" ]; #cosmos in future?
        default = "hyprland";
        description = "The compositor to use";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.hyprland;
        description = "The compositor package to use";
      };
    };
  };

  config = mkIf cfg.enable {
    services = {
      displayManager.sddm = {
        enable = cfg.enable;
        wayland.enable = (cfg.compositor.type == "hyprland");
        theme = "${import ./sddm-theme.nix { inherit pkgs; }}";
      };
      gvfs.enable = true; # for thunar 
    };

    programs = {
      hyprland = mkIf (cfg.compositor.type == "hyprland") {
        enable = cfg.compositor.enable;
        package = cfg.compositor.package;
        xwayland.enable = true;
      };
    };
    services = {
      hypridle = mkIf (cfg.compositor.type == "hyprland") {
        enable = cfg.compositor.enable;
      };
    };
    environment.systemPackages = with pkgs; [
       gparted
       polkit_gnome
       libsForQt5.qt5.qtquickcontrols2
       libsForQt5.qt5.qtgraphicaleffects
    ];
    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
      };
    };
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
    };
    security = {
      rtkit.enable = true;
      pam.services.hyprlock = { };
      polkit.enable = true;
    };
    assertions = [
      {
        assertion = cfg.compositor.enable -> cfg.compositor.type != null;
        message = "If compositor is enabled, a type must be specified.";
      }
    ];
  };
}
