{
  inputs,
  outputs,
  pkgs,
  lib,
  color-scheme,
  ...
}: let
  inherit (lib) mkOption types;
  nrfconnectXwayland = pkgs.symlinkJoin {
    name = "nrfconnect-xwayland";
    paths = [pkgs.nrfconnect];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/nrfconnect \
        --set QT_QPA_PLATFORM xcb \
        --set ELECTRON_OZONE_PLATFORM_HINT x11 \
        --set __GLX_VENDOR_LIBRARY_NAME nvidia
    '';
  };
in {
  options.application = {
    wrap-gl = pkgs.lib.mkOption {
      type = pkgs.lib.types.bool;
      default = false;
      description = "Whether to wrap applications with nixGL";
    };
    minimalTerminal = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable a minimal terminal configuration.";
      };
    };
  };

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./themes
  ];
  config = {
    colorScheme = color-scheme;
    programs.home-manager.enable = true;
    home.packages = with pkgs; [
      inputs.lavix.packages.${pkgs.system}.default
      killall
      htop
      btop
      gnumake
      kew
      vlc
      obsidian
      element-desktop
      xournalpp
      jq
      nrfconnectXwayland
    ];
    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
  };
}
