{ ... }: {
  imports = [
    ./programs/standalone-terminal.nix
    ./common.nix
  ];
  targets.genericLinux.enable = true;
  home = {
    username = "wkrupski";
    homeDirectory = "/home/wkrupski";
  };
}
