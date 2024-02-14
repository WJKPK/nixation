{ pkgs, config, specialArgs, ... }:
  let
    inherit (specialArgs) isNixos;
    wrapNixGL = pkgs.callPackage (import ./../wrap-nix-gl.nix) { };
    kitty = if !isNixos then wrapNixGL pkgs.kitty else pkgs.kitty;
  in {
  home.packages = with pkgs; [
    eza
  ];
  programs = {
    kitty = {
      enable = true;
      package = kitty;
      font = {
        name = "jetbrains mono nerd font";
        size = 12;
      };
      environment = { };
      keybindings = { };
      settings = {
        shell = "zsh";
        scrollback_lines = 10000;
        enable_audio_bell = false;
      };
      extraConfig = ''
        include theme.conf
      '';
    };
  };
  home.shellAliases = {
    ls = "eza --icons=always";
    ll="eza -l --icons=always --smart-group -F";
    nix-shell = "nix-shell --command zsh";
    nd = "nix develop --command zsh";
    ns = "nix shell --command zsh";
  };

  home.file = {
    ".config/kitty/theme.conf" = {
    text = ''
      # The basic colors
      foreground              #${config.colorScheme.palette.base05}
      background              #${config.colorScheme.palette.base00}
      selection_foreground    #${config.colorScheme.palette.base00}
      selection_background    #${config.colorScheme.palette.base06}
      
      # Cursor colors
      cursor                  #${config.colorScheme.palette.base06}
      cursor_text_color       #${config.colorScheme.palette.base00}
      
      # URL underline color when hovering with mouse
      url_color               #${config.colorScheme.palette.base06}
      
      # Kitty window border colors
      active_border_color     #${config.colorScheme.palette.base07}
      inactive_border_color   #${config.colorScheme.palette.base07}
      bell_border_color       #${config.colorScheme.palette.base03}
      
      # OS Window titlebar colors
      wayland_titlebar_color system
      macos_titlebar_color system
      
      # Tab bar colors
      active_tab_foreground   #${config.colorScheme.palette.base01}
      active_tab_background   #${config.colorScheme.palette.base0E}
      inactive_tab_foreground #${config.colorScheme.palette.base05}
      inactive_tab_background #${config.colorScheme.palette.base01}
      tab_bar_background      #${config.colorScheme.palette.base01}
      
      # Colors for marks (marked text in the terminal)
      mark1_foreground #${config.colorScheme.palette.base00}
      mark1_background #${config.colorScheme.palette.base07}
      mark2_foreground #${config.colorScheme.palette.base00}
      mark2_background #${config.colorScheme.palette.base0E}
      mark3_foreground #${config.colorScheme.palette.base00}
      mark3_background #${config.colorScheme.palette.base0C}
      
      # The 16 terminal colors
      
      # black
      color0 #${config.colorScheme.palette.base03}
      color8 #${config.colorScheme.palette.base04}
      
      # red
      color1 #${config.colorScheme.palette.base08}
      color9 #${config.colorScheme.palette.base09}
      
      # green
      color2  #${config.colorScheme.palette.base0B}
      color10 #${config.colorScheme.palette.base0B}
      
      # yellow
      color3  #${config.colorScheme.palette.base0A}
      color11 #${config.colorScheme.palette.base0A}
      
      # blue
      color4  #${config.colorScheme.palette.base0D}
      color12 #${config.colorScheme.palette.base0D}
      
      # magenta
      color5  #${config.colorScheme.palette.base0F}
      color13 #${config.colorScheme.palette.base0F}
      
      # cyan
      color6  #${config.colorScheme.palette.base0C}
      color14 #${config.colorScheme.palette.base0C}
      
      # white
      color7  #${config.colorScheme.palette.base05}
      color15 #${config.colorScheme.palette.base06}
    '';
    };
  };
}
