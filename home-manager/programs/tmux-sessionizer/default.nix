{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    fzf
    tmux-sessionizer
  ];

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    aggressiveResize = true;
    newSession = false;
    escapeTime = 10;
    historyLimit = 10000;
    keyMode = "vi";
    shortcut = "a";
    terminal = "xterm-256color";
    baseIndex = 1;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = gruvbox;
        extraConfig = ''
          set -g @tmux-gruvbox 'dark'
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

        # lazygit releated
        bind -n C-j if-shell "[ #{pane_current_command} = lazygit ]" "send-keys C-j"  "select-pane -D"
        bind -n C-k if-shell "[ #{pane_current_command} = lazygit ]" "send-keys C-k"  "select-pane -U"
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


