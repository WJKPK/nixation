{ inputs, outputs, pkgs, lib, color-scheme, ... }: 
let inherit (lib) mkOption types;
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
    ];
    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
  };
}
