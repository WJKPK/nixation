{ inputs, ...}: {
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./common.nix
    ./programs
    ./nixos-specific.nix
  ];
  monitors = [
    {
      name = "eDP-1";
      width = 2560;
      height = 1440;
      x = 0;
      workspace = "1";
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
