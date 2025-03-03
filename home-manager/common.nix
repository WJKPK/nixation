{ inputs, outputs, pkgs, lib, ... }: 
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
  options.application = {
    wrap-gl = pkgs.lib.mkOption {
      type = pkgs.lib.types.bool;
      default = false;
      description = "Whether to wrap applications with nixGL";
    };
  };

  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.nix-colors.homeManagerModules.default
    ./themes
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  config = {
    colorScheme = inputs.nix-colors.colorSchemes.catppuccin-macchiato;
    programs.home-manager.enable = true;
    home.packages = with pkgs; [
      killall
      htop
      btop
      logseq
      gnumake
      custom-kew
      vlc
      keepassxc
    ];
    programs.firefox.nativeMessagingHosts = [ pkgs.keepassxc ];
    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
  };
}
