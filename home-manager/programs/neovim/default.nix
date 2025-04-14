{ config, lib, pkgs, ... }: {
  programs.lazygit.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      lazygit
      ripgrep
      fd
      rust-analyzer
      clang-tools
      ruff
      basedpyright
      cmake-language-server
    ] ++ lib.optionals (!config.minimalTerminal.enable) [
      wl-clipboard
      zls
      tinymist
      nixd
      lua-language-server
      luajitPackages.luacheck
      clippy
      statix 
      deadnix
    ];

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];
    extraLuaConfig =
      let
        plugins = with pkgs.vimPlugins; [
          lspkind-nvim
          blink-cmp
          friendly-snippets
          nvim-lspconfig
          nvim-treesitter
          nvim-treesitter-context
          nvim-treesitter-textobjects
          plenary-nvim
          telescope-fzf-native-nvim
          telescope-live-grep-args-nvim
          telescope-nvim
          vim-vsnip
          which-key-nvim
          leap-nvim
          yazi-nvim
          snacks-nvim
          vim-tmux-navigator
          nvim-web-devicons
	      catppuccin-nvim
          nvim-gdb
          { name = "mini.statusline"; path = mini-nvim; }
          { name = "mini.trailspace"; path = mini-nvim; }
          { name = "mini.pairs"; path = mini-nvim; }
          { name = "mini.icons"; path = mini-nvim; }
        ] ++ lib.optionals config.aiCodingSupport.enable [ pkgs.vimPlugins.codecompanion-nvim ];
        mkEntryFromDrv = drv:
          if lib.isDerivation drv then
            { name = "${lib.getName drv}"; path = drv; }
          else
            drv;
        lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
      in
      ''
        vim.g.mapleader = " "
	    vim.g.maplocalleader = "\\"
	    vim.opt.expandtab = true
	    vim.opt.relativenumber = true
	    vim.opt.hidden = true
	    vim.opt.incsearch = true
	    vim.opt.number = true
	    vim.opt.shiftwidth = 4
	    vim.opt.splitbelow = true
	    vim.opt.splitright = true
	    vim.opt.signcolumn = "yes:3"
	    vim.opt.tabstop = 4
	    vim.opt.timeoutlen = 0
	    vim.wo.wrap = false
	    vim.opt.exrc = true
	    vim.cmd("syntax on")
        vim.diagnostic.config({
          virtual_lines = true
        })

        -- Window navigation
        -- vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Navigate to left window' })
        -- vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Navigate to bottom window' })
        -- vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Navigate to top window' })
        -- vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Navigate to right window' })
        
        -- Centered scrolling and search
        vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = 'Scroll down and center' })
        vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = 'Scroll up and center' })
        vim.keymap.set("n", "n", "nzzzv", { desc = 'Next search result and center' })
        vim.keymap.set("n", "N", "Nzzzv", { desc = 'Previous search result and center' })

        vim.g.nix_minimal_mode = ${lib.boolToString config.minimalTerminal.enable}
        vim.g.ai_support = ${lib.boolToString config.aiCodingSupport.enable}
        vim.g.ai_model = "${config.aiCodingSupport.llmModelName}"
        require("lazy").setup({
          defaults = {
            lazy = true,
          },
          dev = {
            -- reuse files from pkgs.vimPlugins.*
            path = "${lazyPath}",
            patterns = { "" },
            -- fallback to download
            fallback = false,
            install = { missing = false, },
          },
          spec = {
            -- The following configs are needed for fixing lazyvim on nix
            -- force enable telescope-fzf-native.nvim
            { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
            -- import/override with your plugins
            { import = "plugins" },
            -- disable mason.nvim, use programs.neovim.extraPackages
            { "williamboman/mason-lspconfig.nvim", enabled = false },
            { "williamboman/mason.nvim", enabled = false },
          },
        })
        vim.g.catppuccin_flavour = "macchiato"
        vim.cmd.colorscheme "catppuccin"
      '';
  };

  # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
  xdg.configFile."nvim/parser".source =
    let
      parsers = pkgs.symlinkJoin {
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
      };
    in
    "${parsers}/parser";

  # Normal LazyVim config here, see https://github.com/LazyVim/starter/tree/main/lua
  xdg.configFile."nvim/lua".source = ./lua;
}
