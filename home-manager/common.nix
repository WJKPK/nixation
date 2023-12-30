{ inputs, outputs, pkgs, ... }: {
  imports = [
    inputs.hyprland.homeManagerModules.default
    inputs.nix-colors.homeManagerModules.default
    ./programs 
    ./themes
    ./wallpapers
  ] ++ (builtins.attrValues outputs.homeManagerModules);
  nixpkgs = {
    # You can add overlays here
    overlays = [
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

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-frappe;

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

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    kitty
    firefox
    pavucontrol
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
    xfce.xfce4-appfinder
    xfce.xfce4-settings
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xfce.ristretto
    xfce.tumbler
    gnome.file-roller
    grim
    slurp
    gnumake
    cmake
    gparted
    transmission-gtk
    nerdfonts
    distrobox
    eza
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
