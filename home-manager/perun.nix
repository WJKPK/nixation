{pkgs, inputs, ...}: {
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
    ./programs/hyprshade
    ./programs/librewolf
    ./programs/devcontainers-workflow.nix
#    ./programs/prusa-slicer
    ./programs/keepassxc
  ];
  home = {
    username = "kruppenfield";
    homeDirectory = "/home/kruppenfield";
  };

  programs.git = {
    enable = true;
    userEmail = "krupskiwojciech@gmail.com";
    userName = "WJKPK";
  };

  desktop.addons.waybar.enable = true;
  home.packages = with pkgs; [
    nvtopPackages.full
    stm32cubemx
    xfce.xfburn
    heroic
    rtl-sdr
    rtl_433
    sdrangel
    prusa-slicer
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}

