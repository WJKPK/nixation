{ config, ... }: { 
  programs.yazi = {
    enable = true;

    enableZshIntegration = true;

    settings = {
      manager = {
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
        { run = "close"; on = [ "<Esc>" ]; } 
      ];
    };
  };
  home.file = {
    ".config/yazi/theme.toml".source = ./frappe.toml;
  };
}
