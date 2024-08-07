{pkgs, ...}: {
  imports = [
    ./common.nix
    ./nixos-specific.nix
    ./programs
  ];
  monitors = [
    {
      name = "DP-1";
      width = 3440;
      height = 1440;
      x = 0;
      workspace = "1";
      scale = 1.0;
      refreshRate = 165; 
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

  home.packages = with pkgs; [
    nvtopPackages.full
  ];
}

