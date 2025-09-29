{ config, ... }: { 
  programs.yazi = {
    enable = true;
    # Prevent Home Manager from installing yazi, it comes from lavix
    package = null;

    enableZshIntegration = true;

    settings = {
      mgr = {
        ratio = [ 1 3 7 ];
        sort_by = "alphabetical";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_hidden = true;
        show_symlink = true;
      };
      preview = {
        tab_size = 2;
        max_width = 2000;
        max_height = 1400;
        cache_dir = "${config.xdg.cacheHome}";
      };
    };

    keymap = {
      manager.prepend_keymap = [
        { 
          run = "close"; on = [ "<Esc>" ]; 
        } 
        {
          run = [ 
            "shell -- for path in \"$@\"; do echo \"file://$path\"; done | wl-copy -t text/uri-list" 
            "yank" 
          ];
          on = [ "y" ];
        }
      ];
    };
  };
  home.file = {
    ".config/yazi/theme.toml".source = ./gruvbox.toml;
  };
}
