{pkgs, config, lib, ...}: {
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
      telescope-fzf-native-nvim
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
      markview-nvim
      nvim-web-devicons
    ];

    extraPackages = with pkgs; [
      ripgrep
      fd
      rust-analyzer
      clang-tools_16
      ruff
      basedpyright
      cmake-language-server
    ] ++ lib.optionals (!config.minimalTerminal.enable) [
      wl-clipboard
      zls
      tinymist
      nixd
      lua-language-server
    ];

    extraConfig = let
      luaRequire = module: builtins.readFile (
        builtins.toString ./config + "/${module}"
      );
      
      modules = [
        "utils.lua"
        "vim-setup.lua"
        "code-processing.lua"
        "git-integration.lua"
        "theming.lua"
        "which-key.lua"
        "dashboard.lua"
        "navigation.lua"
      ];
      
      luaConfig = ''
        vim.g.nix_minimal_mode = ${lib.boolToString config.minimalTerminal.enable}
        ${builtins.concatStringsSep "\n" (map luaRequire modules)}
      '';
    in ''
      lua << EOF
      ${luaConfig}
      EOF
    '';
  };

  xdg.configFile."nvim/parser".source = "${pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
      c
      rust
      cpp
      cmake
      python
      query
    ]++ lib.optionals (!config.minimalTerminal.enable) [
      lua
      nix
      latex
      typst
      markdown
      markdown_inline
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
