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
      };
  }; in {
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
      neogit
      nvim-autopairs
      nvim-cmp
      nvim-colorizer-lua
      nvim-lspconfig
      nvim-tree-lua
      rainbow-delimiters-nvim
      nvim-treesitter
      plenary-nvim
      telescope-ui-select-nvim
      telescope-fzy-native-nvim
      telescope-nvim
      vim-vsnip
      which-key-nvim
      dashboard-nvim
      nvim-web-devicons
      nerdtree
      leap-nvim
      toggleterm-nvim
      gen-nvim
      mini-nvim
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

  xdg.configFile."nvim/parser".source = "${pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
      c
      lua
      query
    ])).dependencies;
  }}/parser";

  xdg.desktopEntries.nvim = {
    categories = [ "Utility" "TextEditor" ];
    exec = "${pkgs.kitty}/bin/kitty -e nvim"; # launch with kitty
    genericName = "Text Editor";
    icon = "nvim";
    name = "Neovim";
    terminal = false; # dont launch with default terminal
  };
}
