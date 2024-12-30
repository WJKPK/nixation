{...}: {
  imports = [
    ./common.nix
    ./nixos-specific.nix
    ./programs
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
}
