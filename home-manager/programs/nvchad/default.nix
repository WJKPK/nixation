{ pkgs, outputs, ... }: {
  programs.neovim = { 
    enable = true;
  };

  home.file = {
    ".config/nvim/".source = "${outputs.packages.x86_64-linux.nvchad}";
  };
}
