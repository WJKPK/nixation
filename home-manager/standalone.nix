{ pkgs, outputs, inputs, specialArgs, osConfig ? null, ... }: {
  targets.genericLinux.enable = builtins.isNull osConfig;
  imports = [
    ./programs/kitty
    ./programs/zsh
    ./programs/git
    ./programs/direnv
    ./programs/rofi
    ./programs/tmux-sessionizer
    ./programs/yazi
    ./programs/btop
    ./programs/kicad
    ./programs/librewolf
    ./programs/devcontainers-workflow.nix
    ./programs/keepassxc
    ./common.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
      inputs.nur.overlays.default
      inputs.nixgl.overlay
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  application.wrap-gl = true;
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    libreoffice
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    cascadia-code
    distrobox
  ];

  home = {
    username = "wkrupski";
    homeDirectory = "/home/wkrupski";
    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      LC_ADDRESS = "pl_PL.UTF-8";
      LC_IDENTIFICATION = "pl_PL.UTF-8";
      LC_MEASUREMENT = "pl_PL.UTF-8";
      LC_MONETARY = "pl_PL.UTF-8";
      LC_NAME = "pl_PL.UTF-8";
      LC_NUMERIC = "pl_PL.UTF-8";
      LC_PAPER = "pl_PL.UTF-8";
      LC_TELEPHONE = "pl_PL.UTF-8";
      LC_TIME = "pl_PL.UTF-8";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
