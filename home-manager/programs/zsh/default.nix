{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.utilities.zsh;
in {
  options.utilities.zsh = with types; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable zsh.";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      zsh = {
        enable = true;
        initContent = lib.mkIf (!config.application.minimalTerminal.enable) ''
          if [ -z "$TMUX" ]; then
            tms start
          fi
        '';
        oh-my-zsh = {
          enable = true;
          theme = "bira";
          plugins = [
            "git"
          ];
        };

        autosuggestion.enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
      };
    };
  };
}
