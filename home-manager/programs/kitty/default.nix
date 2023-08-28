{ config, pkgs, ... }: {
  programs = {
    kitty = {
      enable = true;
      font = {
        name = "jetbrains mono nerd font";
        size = 12;
      };
      environment = { };
      keybindings = { };
      settings = {
        shell = "zsh";
        scrollback_lines = 10000;
        enable_audio_bell = false;
      };
      extraConfig = ''
        include theme.conf
      '';
    };
  };

  xdg.configFile."kitty/theme.conf".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/dexpota/kitty-themes/c4bee86c/themes/Monokai.conf";
    hash = "sha256-zR7f4Nl3pUGZh+CsrEqceN56fD7Jk5uVFk8yYkuTjOA=";
  };
}
