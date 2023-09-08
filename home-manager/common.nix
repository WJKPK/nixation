{ inputs, outputs, pkgs, ... }: {
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./programs 
    ./themes
    ./wallpapers
    ./monitors.nix
    ./gpu.nix
  ];

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

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userEmail = "krupskiwojciech@gmail.com";
    userName = "WJKPK";
  };

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
