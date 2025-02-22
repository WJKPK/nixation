{pkgs, ...}:
let
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      cmp-spell
      cmp-treesitter
      cmp-vsnip
      friendly-snippets
      gitsigns-nvim
      lightline-vim
      lspkind-nvim
      nvim-autopairs
      nvim-cmp
      vim-fugitive
      nvim-colorizer-lua
      nvim-lspconfig
      nvim-treesitter
      plenary-nvim
      telescope-fzy-native-nvim
      telescope-live-grep-args-nvim
      telescope-nvim
      vim-vsnip
      which-key-nvim
      dashboard-nvim
      leap-nvim
      yazi-nvim
      toggleterm-nvim
      mini-nvim
      vim-tmux-navigator
      devdocs-vim
    ];

    extraPackages = with pkgs; [
      gcc
      ripgrep
      fd
      nixd 
      rust-analyzer
      wl-clipboard
      clang-tools_16
      lua-language-server
      cmake-language-server
      tinymist
      zls
    ];

    extraConfig = let
      luaRequire = module:
        builtins.readFile (builtins.toString
          ./config
          + "/${module}.lua");
      luaConfig = builtins.concatStringsSep "\n" (map luaRequire [
        "utils"
        "vim-setup"
        "code-processing"
        "git-integration"
        "theming"
        "which-key"
      	"dashboard"
        "navigation"
      ]);
    in ''
      lua <<
      ${luaConfig}
    '';
  };

  xdg.configFile."nvim/parser".source = "${pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
      c
      rust
      lua
      cpp
      python
      query
    ])).dependencies;
  }}/parser";

  xdg.desktopEntries.nvim = {
    categories = [ "Utility" "TextEditor" ];
    exec = "${pkgs.kitty}/bin/kitty -e nvim";
    genericName = "Text Editor";
    icon = "nvim";
    name = "Neovim";
    terminal = false;
  };
}
