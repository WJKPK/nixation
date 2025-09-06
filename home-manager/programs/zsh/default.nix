{ config, lib, ... }: {
    programs = {
        zsh = {
            enable = true;
            initExtra = lib.mkIf (!config.application.minimalTerminal.enable) ''
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
#    home.file.".zshrc".text = ''
#      export PATH=$HOME/bin:/usr/local/bin:$PATH
#      #export ZSH="$HOME/.oh-my-zsh"
#
#      ZSH_THEME="bira"
#    '';
}
