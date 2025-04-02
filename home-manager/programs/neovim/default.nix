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
        plugin = pkgs.vimPlugins.codecompanion-nvim; 
        type = "lua";
        config = ''
          require("codecompanion").setup {
            display = {
              action_palette = {
                provider = "telescope",
              },
            },
            opts = {
              system_prompt = function(opts)
                return [[
                  You are a technical advisor to an experienced software engineer working in Neovim.
                  
                  Assume advanced programming knowledge and familiarity with software engineering principles.
                  
                  When responding:
                  - Prioritize technical depth and architectural implications
                  - Focus on edge cases, performance considerations, and scalability
                  - Discuss trade-offs between different approaches when relevant
                  - Skip explanations of standard patterns or basic concepts unless requested
                  - Reference advanced patterns, algorithms, or design principles when applicable
                  - Prefer showing code over explaining it unless analysis is specifically requested
                  
                  For code improvement:
                  - Focus on optimizations beyond obvious refactorings
                  - Highlight potential concurrency issues, memory management concerns, or runtime complexity
                  - Consider backwards compatibility, maintainability, and testing implications
                  - Suggest modern idioms and language features when appropriate
                  
                  For architecture discussions:
                  - Consider system boundaries, coupling concerns, and dependency management
                  - Address long-term maintenance and extensibility implications
                  - Discuss relevant architectural patterns without overexplaining them
                  
                  Deliver responses with professional brevity. Skip preamble and unnecessary context.
                ]]
              end,
            },
            strategies = {
              chat = {
                adapter = "ollama-qwen2.5-coder",
                slash_commands = {
                  ['buffer'] = { opts = { provider = 'telescope' } },
                  ['file'] = { opts = { provider = 'telescope' } },
                  ["files"] = { opts = { provider = 'telescope' } },
                },
              },
              inline = {
                adapter = "ollama-qwen2.5-coder",
              },
            },
            adapters = {
              ["ollama-qwen2.5-coder"] = function()
                return require("codecompanion.adapters").extend(
                  "ollama",
                  {
                    name = "qwen2.5-coder",
                    schema = {
                      model = {
                        default = "${config.aiCodingSupport.llmModelName}",
                      },
                      num_ctx = {
                        default = 16384,
                      },
                      num_predict = {
                        default = -1,
                      },
                    },
                  }
                )
              end,
            },
        }
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

