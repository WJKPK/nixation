{ inputs, outputs, pkgs, ... }: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./themes
  ] ++ (builtins.attrValues outputs.homeManagerModules);
  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
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

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-frappe;

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
   (nerdfonts.override { fonts = [ "JetBrainsMono" "NerdFontsSymbolsOnly" "CascadiaCode" ]; })
    stm32cubemx
    saleae-logic-2
    xfce.thunar
    xfce.xfce4-appfinder
    xfce.xfce4-settings
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xfce.ristretto
    xfce.tumbler
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
