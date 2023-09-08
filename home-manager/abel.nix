{...}: {
  imports = [
    ./common.nix
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
  gpus = [
    {
      nvidia = {
        enable = true;
        prime = true;
      };
    }
  ];
}
