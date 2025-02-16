{ pkgs, outputs, inputs, osConfig ? null, ... }: {
  targets.genericLinux.enable = builtins.isNull osConfig;
  imports = [
    ./programs/neovim
    ./programs/yazi
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
      inputs.nixgl.overlay
    ];
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    cascadia-code
  ];

  home = {
    username = "vscode";
    homeDirectory = "/home/vscode";
  };
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
