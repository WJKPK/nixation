{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.utilities.tmuxSessionizer;
in {
  options.utilities.tmuxSessionizer = with types; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable tmux-sessionizer.";
    };
  };

  config = mkIf cfg.enable {
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
      ];

      extraConfig = ''
        bind | split-window -h
        bind _ split-window -v
        bind t display-popup -E "tms"

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
  };
}
