{ ... }: {
    programs = {
        zsh = {
            enable = true;
            oh-my-zsh = {
                enable = true;
                theme = "bira";
                plugins = [
                    "git"
                ];
            };

            enableAutosuggestions = true;
            enableCompletion = true;
            syntaxHighlighting.enable = true;
        };
    };
home.file.".zshrc".text = ''
  export PATH=$HOME/bin:/usr/local/bin:$PATH
  # Path to your oh-my-zsh installation.
  #export ZSH="$HOME/.oh-my-zsh"
  
  ZSH_THEME="bira"
'';
}
