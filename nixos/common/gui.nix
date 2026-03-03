{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf mkMerge;
  compositorSettings = {
    niri = {
      programs.niri.enable = true;
      programs.niri.package = pkgs.niri;
      programs.gpu-screen-recorder.enable = true;
      services.gnome.evolution-data-server.enable = true;
      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = 1;
        GDK_BACKEND = "wayland";
        QT_QPA_PLATFORM = "wayland";
        SDL_VIDEODRIVER = "wayland";
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        XDG_CURRENT_DESKTOP = "niri";
      };
      security.pam.services.swaylock = {};
      services = {
        upower.enable = true;
        power-profiles-daemon.enable = true;
      };
      environment.systemPackages = with pkgs; [
        xwayland-satellite
        gpu-screen-recorder
      ];
      xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];
    };
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
in {
  options.graphicalEnvironment = {
    enable = mkEnableOption "Enable graphical environment configuration";
    compositor = {
      enable = mkEnableOption "Enable compositor configuration";
      type = mkOption {
        type = types.enum ["niri"];
        default = "niri";
        description = "The compositor / desktop environment to use.";
      };
    };
  };

  config = let
    cfg = config.graphicalEnvironment;
    nvidia-cfg = config.nvidiaManagement;
  in
    mkMerge [
      (mkIf cfg.enable commonWaylandSettings)
      (mkIf (cfg.enable && cfg.compositor.enable && cfg.compositor.type == "niri") (
        mkMerge [
          compositorSettings.niri
          (mkIf (nvidia-cfg.driver.enable && !nvidia-cfg.optimus.enable) nvidiaEnv)
        ]
      ))
      {
        assertions = [
          {
            assertion = cfg.compositor.enable -> cfg.compositor.type != null;
            message = "If compositor is enabled, a type must be specified.";
          }
          {
            assertion = (cfg.compositor.enable && cfg.compositor.type == "niri") -> (config.nvidiaManagement or {} ? driver && config.nvidiaManagement or {} ? optimus);
            message = "nvidiaManagement must be defined when using Niri with NVIDIA settings.";
          }
        ];
      }
    ];
}
