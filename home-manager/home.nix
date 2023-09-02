# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix 

    #inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.hyprland.homeManagerModules.default
    ./programs
    ./themes
    ./wallpapers
  ] ++ (builtins.attrValues outputs.homeManagerModules);
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "kruppenfield";
    homeDirectory = "/home/kruppenfield";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.git.userEmail = "krupskiwojciech@gmail.com";
  programs.git.userName = "WJKPK";

  home.packages = with pkgs; [
    kitty
    mako
    firefox
    pavucontrol
    mpd
    mpc-cli
    brightnessctl
    pamixer
    openscad
    glxinfo
    nerdfonts
    cura
    stm32cubemx
    saleae-logic-2
    gcc
    rustup
    unzip
    ripgrep
    wireguard-tools
    xfce.thunar
    grim
    slurp
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
