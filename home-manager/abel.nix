{...}: {
  imports = [
    ./common.nix
    ./nixos-specific.nix
    ./programs
  ];
  monitors = [
    {
      name = "eDP-1";
      width = 2560;
      height = 1440;
      x = 0;
      workspace = "1";
      scale = 1.25;
      enabled = true;
      primary = true;
    }
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
