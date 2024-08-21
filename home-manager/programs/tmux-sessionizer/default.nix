{ pkgs, lib, config, ... }: {
  home.packages = with pkgs; [
    fzf
    tmux-sessionizer
  ];

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
  };

  home.file = {
    ".config/tms/config.toml" = {
     text = ''
       session_sort_order = "LastAttached"

       [[search_dirs]]
       path = "${config.home.homeDirectory}/Seas"
       depth = 10
     '';
    };
  };
}


