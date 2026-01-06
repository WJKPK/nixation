{ lib, pkgs, config, color-scheme, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf mkMerge mkForce;

  compositorSettings = {
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
  };

  hyprlandEnv = {
    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = 0;
      };
    };
    environment.systemPackages = with pkgs; [ hyprpolkitagent ];
    xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  nvidiaEnv = {
    environment = {
      sessionVariables = {
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        LIBVA_DRIVER_NAME = "nvidia";
        NVD_BACKEND = "direct";
      };
    };
  };

  commonWaylandSettings = {
      services.displayManager.sddm = {
        package = pkgs.kdePackages.sddm;
        enable = true;
        theme = "sddm-astronaut-theme";
        #theme = "${import ./sddm-theme.nix { inherit pkgs color-scheme; }}";
        wayland.enable = true;
        extraPackages = with pkgs; [
          kdePackages.qtsvg
          kdePackages.qtmultimedia
          kdePackages.qtvirtualkeyboard
        ];
      };

      services.gvfs.enable = true;
      environment.systemPackages = with pkgs; [
        (sddm-astronaut.override {
          embeddedTheme = "purple_leaves";
        })
        gparted
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

  config = let 
    cfg = config.graphicalEnvironment;
    nvidia-cfg = config.nvidiaManagement;
  in mkMerge [
    (mkIf cfg.enable commonWaylandSettings)
    (mkIf (cfg.enable && cfg.compositor.enable && cfg.compositor.type == "hyprland") (
      mkMerge [
        compositorSettings.hyprland
        hyprlandEnv
        (mkIf (nvidia-cfg.driver.enable && !nvidia-cfg.optimus.enable) nvidiaEnv)
      ]
    ))
    (mkIf (cfg.enable && cfg.compositor.enable && cfg.compositor.type == "cosmic") compositorSettings.cosmic)
    {
      assertions = [
        {
          assertion = cfg.compositor.enable -> cfg.compositor.type != null;
          message = "If compositor is enabled, a type must be specified.";
        }
        {
          assertion = (cfg.compositor.enable && cfg.compositor.type == "hyprland") -> (config.nvidiaManagement or {} ? driver && config.nvidiaManagement or {} ? optimus);
          message = "nvidiaManagement must be defined when using Hyprland with NVIDIA settings.";
        }
      ];
    }
  ];
}
