{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) optionalAttrs attrByPath mkDefault;

  monitors = osConfig.monitors;
  guiApps = with pkgs; [
    transmission_4-gtk
    openscad
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
    unzip
    distrobox
  ];

  graphicalEnv =
    if osConfig ? graphicalEnvironment
    then osConfig.graphicalEnvironment
    else null;

  compositorType =
    if
      graphicalEnv
      != null
      && attrByPath ["enable"] false graphicalEnv
      && attrByPath ["compositor" "enable"] false graphicalEnv
    then attrByPath ["compositor" "type"] null graphicalEnv
    else null;

  compositorEnabled = compositorType != null;
  isNiri = compositorType == "niri";
  isHyprland = compositorType == "hyprland";
  idleManagerDefault =
    if isNiri
    then "swayidle"
    else "hypridle";
in
  {
    services.syncthing.enable = true;
    home.packages =
      nonGuiApps
      ++ (lib.optionals
        (lib.any (m: m.enabled) monitors)
        guiApps);
  }
  // optionalAttrs compositorEnabled {
    desktop.environment.niri.enable = mkDefault isNiri;
    desktop.environment.hyprland.enable = mkDefault isHyprland;

    desktop.addons.waybar.enable = mkDefault isHyprland;
    desktop.addons.hyprlock.enable = mkDefault isHyprland;
    desktop.addons.hyprshade.enable = mkDefault isHyprland;
    desktop.addons.dunst.enable = mkDefault isHyprland;

    desktop.addons.idle = {
      enable = mkDefault true;
      manager = mkDefault idleManagerDefault;
    };
  }
