{pkgs, ...}: {
  imports = [
    ./nixos-specific.nix
    ./wallpapers
  ];

  utilities.zsh.enable = true;
  utilities.git.enable = true;
  utilities.kitty.enable = true;
  utilities.direnv.enable = true;
  utilities.tmuxSessionizer.enable = true;
  utilities.yazi.enable = true;
  utilities.btop.enable = true;
  utilities.openscad.enable = true;
  desktop.addons.rofi.enable = true;
  utilities.librewolf.enable = true;
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
