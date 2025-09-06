{ inputs, outputs, pkgs, lib, ... }: 
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
    inputs.catppuccin.homeModules.catppuccin
    inputs.nix-colors.homeManagerModules.default
    ./themes
  ] ++ (builtins.attrValues outputs.homeManagerModules);
  config = {
    colorScheme = inputs.nix-colors.colorSchemes.catppuccin-macchiato;
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
    ];
    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
  };
}
