{ pkgs, ...}: {
  imports = [
    ./common.nix
    ./nixos-specific.nix
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
    ./programs/dunst
    ./programs/hyprland
    ./programs/waybar
    ./programs/hyprlock
    ./programs/librewolf
    ./programs/hyprshade
    ./programs/keepassxc
  ];

  desktop.addons.waybar.enable = true;
  home = {
    username = "kruppenfield";
    homeDirectory = "/home/kruppenfield";
  };
  programs.git = {
    enable = true;
    userEmail = "krupskiwojciech@gmail.com";
    userName = "WJKPK";
  };
  home.packages = with pkgs; [
    nvtopPackages.full
    arc-theme
    stm32cubemx
    saleae-logic-2
    xfce.thunar
    xfce.xfce4-appfinder
    xfce.xfce4-settings
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xfce.ristretto
    xfce.tumbler
    nrfutil
    nrf-command-line-tools
    segger-jlink
    rtl-sdr
    rtl_433
    sdrangel
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
