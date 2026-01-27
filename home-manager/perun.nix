{
  pkgs,
  inputs,
  ...
}: {
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
    ./programs/niri
    ./programs/waybar
    ./programs/hyprlock
    ./programs/hyprshade
    ./programs/librewolf
    ./programs/devcontainers-workflow.nix
    #./programs/prusa-slicer
    ./programs/television
    ./programs/keepassxc
  ];

  utilities.kitty.enable = true;
  utilities.zsh.enable = true;
  utilities.git.enable = true;
  utilities.direnv.enable = true;
  utilities.tmuxSessionizer.enable = true;
  utilities.yazi.enable = true;
  utilities.btop.enable = true;
  utilities.openscad.enable = true;
  desktop.addons.rofi.enable = true;
  desktop.environment.niri.enable = true;
  utilities.librewolf.enable = true;
  utilities.devcontainersWorkflow.enable = true;
  utilities.television.enable = true;
  utilities.keepassxc.enable = true;
  utilities.kicad.enable = true;

  desktop.addons.waybar.enable = false;
  desktop.addons.hyprlock.enable = false;
  desktop.addons.hyprshade.enable = false;
  desktop.environment.hyprland.enable = false;
  desktop.addons.dunst.enable = false;

  home = {
    username = "kruppenfield";
    homeDirectory = "/home/kruppenfield";
  };

  programs.git = {
    enable = true;
    settings.user = {
      email = "krupskiwojciech@gmail.com";
      name = "WJKPK";
    };
  };
  home.packages = with pkgs; [
    nvtopPackages.full
    stm32cubemx
    xfburn
    heroic
    rtl-sdr
    rtl_433
    sdrangel
    prusa-slicer
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
