{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;

  # Each compositor is a *module function*.
  compositorModules = {
    hyprland = {
      programs.hyprland = {
        enable = true;
        package = pkgs.hyprland;
        xwayland.enable = true;
      };
      services.hypridle.enable = true;
      security.pam.services.hyprlock = {};
    };

    cosmic = {
      services.desktopManager.cosmic.enable = true;
    };
  };
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

  config = let cfg = config.graphicalEnvironment;
  in
    mkIf cfg.enable ({
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = "${import ./sddm-theme.nix { inherit pkgs; }}";
      };

      services.gvfs.enable = true;

      environment.systemPackages = with pkgs; [
        gparted
        polkit_gnome
        libsForQt5.qt5.qtquickcontrols2
        libsForQt5.qt5.qtgraphicaleffects
      ];

      systemd.user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
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
        polkit.enable = true;
      };

      assertions = [
        {
          assertion = cfg.compositor.enable -> cfg.compositor.type != null;
          message = "If compositor is enabled, a type must be specified.";
        }
      ];
    } // mkIf (cfg.compositor.enable && cfg.compositor.type == "hyprland") compositorModules.hyprland
      // mkIf (cfg.compositor.enable && cfg.compositor.type == "cosmic") compositorModules.cosmic
  );
}
