{ inputs, outputs, pkgs, ... }: 
let
  custom-kew = pkgs.kew.overrideAttrs (oldAttrs: {
  version = "2.8.2";
  src = pkgs.fetchFromGitHub {
    owner = "ravachol";
    repo = "kew";
    rev = "52745bebb33614afb6c3670874bb5b4049057611";
    hash = "sha256-engA05eoq4SmRV8LXG7wHsI6XNVoSoI0BL7jb186u4o=";
  };
  buildInputs = with pkgs;[
    ffmpeg
    fftwFloat
    chafa
    glib
    opusfile
    libopus
    libvorbis
  ];
   buildFlags = "-I${pkgs.opusfile.dev}/include/opus";
});
in {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.nix-colors.homeManagerModules.default
    ./themes
  ] ++ (builtins.attrValues outputs.homeManagerModules);
  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.stable-packages
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = [
        "electron-27.3.11" # logseq dep
      ];
    };
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-macchiato;

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.symbols-only
    cascadia-code
    arc-theme
    stm32cubemx
    saleae-logic-2
    xfce.thunar
    xfce.xfce4-appfinder
    xfce.xfce4-settings
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xfce.ristretto
    xfce.tumbler
    killall
    htop
    btop
    logseq
    gnumake
    custom-kew
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
