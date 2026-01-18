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
    #./programs/dunst
    #./programs/hyprland
    ./programs/niri
    #./programs/waybar
    #./programs/hyprlock
    #./programs/hyprshade
    ./programs/librewolf
    ./programs/keepassxc
  ];

  #desktop.addons.waybar.enable = true;
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
    stm32cubemx
    saleae-logic-2
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
