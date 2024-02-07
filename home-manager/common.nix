{ inputs, outputs, pkgs, ... }: {
  imports = [
    inputs.hyprland.homeManagerModules.default
    inputs.nix-colors.homeManagerModules.default
    ./themes
    ./wallpapers
  ] ++ (builtins.attrValues outputs.homeManagerModules);
  nixpkgs = {
    # You can add overlays here
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      outputs.overlays.nixGL-overlay
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-frappe;

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
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
