{ pkgs, config, ... }: {
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
    terminal = "xterm-256color";
    baseIndex = 1;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'frappe'
          set -g @catppuccin_date_time ""
          set -g @catppuccin_user "off"
          set -g @catppuccin_host "on"
        '';
      }
     {
        plugin = resurrect; # Used by tmux-continuum
        # Use XDG data directory
        # https://github.com/tmux-plugins/tmux-resurrect/issues/348
        extraConfig = ''
          set -g @resurrect-dir '$HOME/.cache/tmux/resurrect'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-pane-contents-area 'visible'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5' # minutes
        '';
      }
    ];

    extraConfig = ''
        bind | split-window -h
        bind _ split-window -v
        bind t display-popup -E "tms switch"
        # yazi releated
        set -g allow-passthrough on
        set -ga update-environment TERM
        set -ga update-environment TERM_PROGRAM
    '';
  };

  home.shellAliases = {
    ts = "tms switch";
  };

  home.file = {
    ".config/tms/config.toml" = {
     text = ''
       session_sort_order = "LastAttached"

       [[search_dirs]]
       path = "${config.home.homeDirectory}/Programowanie"
       depth = 3 

       [[search_dirs]]
       path = "${config.home.homeDirectory}/nixation"
       depth = 2
     '';
    };
  };
}


