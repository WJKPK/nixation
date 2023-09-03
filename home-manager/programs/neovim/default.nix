{pkgs, ...}: {
  programs.neovim = {
    enable = true;

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
      neogit
      nvim-autopairs
      nvim-cmp
      nvim-colorizer-lua
      nvim-lspconfig
      nvim-tree-lua
      nvim-ts-rainbow
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      plenary-nvim
      telescope-fzy-native-nvim telescope-nvim
      vim-floaterm
      vim-sneak
      vim-vsnip
      which-key-nvim
      dashboard-nvim
      nvim-web-devicons
      nerdtree
      leap-nvim
    ];

    extraPackages = with pkgs; [
      gcc
      ripgrep
      fd
      nil
      rust-analyzer
      wl-clipboard
      clang-tools_16
      lua-language-server
      cmake-language-server
    ];

    extraConfig = let
      luaRequire = module:
        builtins.readFile (builtins.toString
          ./config
          + "/${module}.lua");
      luaConfig = builtins.concatStringsSep "\n" (map luaRequire [
        "init"
        "utils"
        "lspconfig"
        "nvim-cmp"
        "theming"
        "treesitter"
        "treesitter-textobjects"
        "which-key"
      	"dashboard"
        "nerdtree"
      ]);
    in ''
      lua << 
      ${luaConfig}
      
    '';
  };
}