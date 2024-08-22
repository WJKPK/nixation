{ pkgs, lib, config, ... }: 
let
  removeUnstableSuffix = packageName:
    let parts = builtins.split "-unstable-[0-9]{4}-[0-9]{2}-[0-9]{2}$" packageName;
    in builtins.head parts;

  pluginConf = plugins:
    builtins.concatStringsSep "\n\n" (map (plugin:
      let name = removeUnstableSuffix (lib.removePrefix "tmuxplugin-" plugin.name);
      in "run-shell ${plugin}/share/tmux-plugins/${name}/${name}.tmux")
      plugins);

  plugins = with pkgs.tmuxPlugins; [
    catppuccin
    vim-tmux-navigator
  ];
in 
{
  home.packages = with pkgs; [
    fzf
    tmux-sessionizer
  ];


  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    aggressiveResize = true;
    newSession = true;
    escapeTime = 10;
    historyLimit = 5000;
    keyMode = "vi";
    shortcut = "a";
    terminal = "tmux-256color";
    baseIndex = 1;
    extraConfig = ''
      ${builtins.readFile ./tmux.conf}
      ${pluginConf plugins}
    '';
  };

  home.file = {
    ".config/tms/config.toml" = {
     text = ''
       session_sort_order = "LastAttached"

       [[search_dirs]]
       path = "${config.home.homeDirectory}/Seas"
       depth = 6 

       [[search_dirs]]
       path = "${config.home.homeDirectory}/nixation"
       depth = 6
     '';
    };
  };
}


