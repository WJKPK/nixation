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
    stable.pulseview
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
in
  {
    imports = [
      ./common.nix
      ./wallpapers
      ./programs/kitty
      ./programs/zsh
      ./programs/git
      ./programs/direnv
      ./programs/rofi
      ./programs/kicad
      ./programs/tmux-sessionizer
      ./programs/yazi
      ./programs/btop
      ./programs/openscad
      ./programs/niri
      ./programs/noctalia
      ./programs/swayidle
      ./programs/librewolf
      ./programs/devcontainers-workflow.nix
      ./programs/television
      ./programs/keepassxc
    ];

    services.syncthing.enable = true;
    home.packages =
      nonGuiApps
      ++ (lib.optionals
        (lib.any (m: m.enabled) monitors)
        guiApps);
  }
  // optionalAttrs compositorEnabled {
    desktop.environment.niri.enable = mkDefault isNiri;
    desktop.environment.noctalia.enable = mkDefault isNiri;
    desktop.addons.swayidle.enable = mkDefault isNiri;
  }
