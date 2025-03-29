{pkgs, config, lib, ...}: {
   home.sessionVariables = {
     ANTHROPIC_API_KEY = "";
  };
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
      minuet-ai-nvim
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
    ] ++ lib.optionals (config.aiCodingSupport.enable) [
      {
        plugin = pkgs.vimPlugins.avante-nvim.overrideAttrs (oldAttrs: {
          src = pkgs.fetchFromGitHub {
            owner = "yetone";
            repo = "avante.nvim";
            rev = "master";
            hash = "sha256-7qvx/VypcaTutrNvIo7kGn+MAetTXYTQRPgRK2+eoDA=";
          };
          version = "unstable";
           nvimSkipModules = oldAttrs.nvimSkipModules ++ [
            "avante.providers.vertex_claude"
            "avante.providers.ollama"
          ]; 
        }); 
        type = "lua";
        config = ''
          local opts = {
            provider = "ollama",
            use_absolute_path = true,
            auto_suggestions_provider = "ollama",
              ---@type AvanteProvider
              ollama = {
                endpoint = "http://localhost:11434",
                model = "${config.aiCodingSupport.llmModelName}",
              },
            behaviour = {
              auto_suggestions = false, -- Experimental stage
              auto_set_highlight_group = true,
              auto_set_keymaps = true,
              auto_apply_diff_after_generation = false,
              support_paste_from_clipboard = true,
            },
            hints = { enabled = true },
            windows = {
              position = "right",
              wrap = true,
              width = 30,
              sidebar_header = {
                align = "center", -- left, center, right for title
                rounded = false,
              },
            },
            highlights = {
              ---@type AvanteConflictHighlights
              diff = {
                current = "DiffText",
                incoming = "DiffAdd",
              },
            },
            --- @class AvanteConflictUserConfig
            diff = {
              autojump = true,
              ---@type string | fun(): any
              list_opener = "copen",
            },
   	      };  
          require("avante_lib").load()
          require("avante").setup()
          require("avante.config").setup(opts)
        '';
      }
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
        vim.g.ai_support = ${lib.boolToString config.aiCodingSupport.enable}
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
