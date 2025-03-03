{ pkgs, lib, config, ... }: let
  guiApps = with pkgs; [
    pavucontrol
    pwvucontrol
    transmission_3-gtk
    openscad
    satty
    hyprshot
    grim
    slurp
    wl-clipboard
    arc-theme
    saleae-logic-2
    xfce.thunar
    xfce.xfce4-appfinder
    xfce.xfce4-settings
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xfce.ristretto
    xfce.tumbler
    logseq
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
    (lib.any (m: m.enabled) config.monitors)
    guiApps);
}

