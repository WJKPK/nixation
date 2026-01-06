{ pkgs, lib, osConfig, ... }: let
  monitors = osConfig.monitors;
  guiApps = with pkgs; [
    pavucontrol
    pwvucontrol
    transmission_4-gtk
    openscad
    satty
    hyprshot
    grim
    slurp
    #wl-clipboard
    arc-theme
    saleae-logic-2
    pulseview
    thunar
    xfce4-appfinder
    xfce4-settings
    thunar-archive-plugin
    thunar-volman
    ristretto
    tumbler
  ];

  nonGuiApps = with pkgs; [
    brightnessctl
    pamixer
    unzip
    distrobox
    procps
  ];
in {
  services.syncthing.enable = true;
  home.packages = nonGuiApps ++ (lib.optionals
    (lib.any (m: m.enabled) monitors)
    guiApps);
}

