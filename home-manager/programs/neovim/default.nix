{pkgs, ...}: 
let
  gen-nvim = pkgs.vimUtils.buildVimPlugin {
      name = "gen.nvim";
      version = "03.05.2024";
      src = pkgs.fetchFromGitHub {
        owner = "David-Kunz";
        repo = "gen.nvim";
        rev = "bd19cf584b5b82123de977b44105e855e61e5f39";
        sha256 = "sha256-0AEB6im8Jz5foYzmL6KEGSAYo48g1bkFpjlCSWT6JeE=";
      }; }; in {
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
      nvim-tree-lua
      nvim-cmp
      vim-fugitive
      nvim-colorizer-lua
      nvim-lspconfig
      nvim-treesitter
      plenary-nvim
      telescope-fzy-native-nvim
      telescope-nvim
      vim-vsnip
      which-key-nvim
      dashboard-nvim
      nerdtree
      leap-nvim
      toggleterm-nvim
      gen-nvim
      mini-nvim
      vim-tmux-navigator
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
    ];

    extraConfig = let
      luaRequire = module:
        builtins.readFile (builtins.toString
          ./config
          + "/${module}.lua");
      luaConfig = builtins.concatStringsSep "\n" (map luaRequire [
        "vim-setup"
        "utils"
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
