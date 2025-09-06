{...}: {
  imports = [
    ./common.nix
    ./nixos-specific.nix
    ./programs/kitty
    ./programs/zsh
    ./programs/git
    ./programs/direnv
    ./programs/tmux-sessionizer
    ./programs/yazi
    ./programs/btop
  ];

  home = {
    username = "kruppenfield";
    homeDirectory = "/home/kruppenfield";
  };

  application.minimalTerminal.enable = true;

  programs.git = {
    enable = true;
    userEmail = "krupskiwojciech@gmail.com";
    userName = "WJKPK";
  };
  home.stateVersion = "24.11";
}
