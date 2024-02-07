{...}: {
  imports = [
    ./programs/wayland-conf.nix
    ./common.nix
    ./own_credentials.nix
  ];
  monitors = [
    {
      name = "DP-1";
      width = 3440;
      height = 1440;
      x = 0;
      workspace = "1";
      refreshRate = 165; 
      enabled = true;
      primary = true;
    }
  ];
}

