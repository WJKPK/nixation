{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./nixos-specific.nix
    ./wallpapers
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
  utilities.librewolf.enable = true;
  utilities.devcontainersWorkflow.enable = true;
  utilities.fzf.enable = true;
  utilities.keepassxc.enable = true;
  utilities.kicad.enable = true;

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
