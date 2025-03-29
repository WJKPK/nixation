{ pkgs, outputs, inputs, specialArgs, osConfig ? null, ... }: {
  targets.genericLinux.enable = builtins.isNull osConfig;
  imports = [
    ./programs/neovim
    ./programs/kitty
    ./programs/zsh
    ./programs/git
    ./programs/direnv
    ./programs/rofi
    ./programs/kicad
    ./programs/tmux-sessionizer
    ./programs/yazi
    ./programs/btop
    ./programs/openscad
    ./programs/librewolf
    ./programs/devcontainers-workflow.nix
    ./programs/keepassxc/
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

  aiCodingSupport = {
    enable = true;
    llmModelName = "qwen2.5-coder:3b";
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
    inputs.dni.packages.${pkgs.system}.default
  ];

  home = {
    username = "wkrupski";
    homeDirectory = "/home/wkrupski";
  };
  monitors = [
    {
      name = "HDMI-1";
      width = 1920;
      height = 1080;
      primary = true;
      enabled = false;
    }
  ];
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
