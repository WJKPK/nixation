{lib, ...}: {
  imports = [
    ./nixos-specific.nix
  ];

  utilities.zsh.enable = true;
  utilities.git.enable = true;
  utilities.kitty.enable = true;
  utilities.direnv.enable = true;
  utilities.tmuxSessionizer.enable = true;
  utilities.yazi.enable = true;
  utilities.btop.enable = true;

  home = {
    username = "kruppenfield";
    homeDirectory = "/home/kruppenfield";
  };

  application.minimalTerminal.enable = true;

  programs.git = {
    enable = true;
    settings.user = {
      email = "krupskiwojciech@gmail.com";
      name = "WJKPK";
    };
  };
  home.stateVersion = "24.11";
}
