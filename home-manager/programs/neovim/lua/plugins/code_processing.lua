return {
    {
        "neovim/nvim-lspconfig",
        dependencies = { 'saghen/blink.cmp' },
        event = { "BufReadPre", "BufNewFile" },
        opts = function()
          local servers = {
            basedpyright = {},
            clangd = {},
            rust_analyzer = {},
            cmake = {},
            ruff = {},
           }
           if not vim.g.nix_minimal_mode then
             servers.nixd = {}
             servers.zls = {}
             servers.lua_ls = {
               settings = {
                 Lua = {
                   diagnostics = {
                     globals = {'vim'},
                   },
                 },
               },
             }
             servers.tinymist = {
               settings = {
                 formatterMode = "typstyle",
                 exportPdf = "onType",
                 semanticTokens = "disable"
               }
             }
           end
           return {
             servers = servers,
           }
        end,
        config = function(_, opts)
          local lspconfig = require('lspconfig')
          for server, config in pairs(opts.servers) do
            -- passing config.capabilities to blink.cmp merges with the capabilities in your
            -- `opts[server].capabilities, if you've defined it
            config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
            lspconfig[server].setup(config)
          end
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "c",
                "rust",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
            },
        },
    },
}
