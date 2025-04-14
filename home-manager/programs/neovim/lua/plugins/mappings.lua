return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            spec = {
                -- Normal mode mappings
                { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Toggle term" },
                { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
                { "<leader>w", "<cmd>Telescope grep_string<cr>", desc = "String Grep" },
                {
                    "<leader>/",
                    "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>",
                    desc = "String Grep",
                },
                { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find File" },
                { "<leader>g", "<cmd>lua Snacks.lazygit()<cr>", desc = "Toggle lazygit" },
                { "<leader>l", group = "LSP" },
                { "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Goto implementation" },
                { "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Goto definition" },
                { "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename under cursor" },
                { "<leader>lr", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "Find all references" },
                { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code action" },
                { "<leader>dw", "<cmd>lua require('mini.trailspace').trim()<cr>", desc = "Delete trailing whitespace" },
                { "<leader>p", '"+p', desc = "Paste from clipboard" },
                { "<leader>P", '"+P', desc = "Paste from clipboard before cursor" },
                { "<leader>y", '"+y', desc = "Yank to clipboard" },
                { "<C-s>", "<cmd>vs<cr>", desc = "Vertical Split" },
                { "<leader>e", "<cmd>Yazi<cr>", desc = "Yazi toggle" },
                { "<leader>s", "<cmd>Yazi cwd<cr>", desc = "Yazi source directory" },
                { "<M-j>", "<cmd>cnext<cr>", desc = "Next quickfix list item" },
                { "<M-k>", "<cmd>cprev<cr>", desc = "Previous quickfix list item" },
                { "<leader>ac", "<cmd>CodeCompanionChat<cr>", desc = "Code Companion Chat", mode = { "n", "v" } },
                { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Actions", mode = { "n", "v" } },
                -- Visual mode mapping
                { "<leader>y", '"+y', desc = "Yank to clipboard", mode = "v" },
            },
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },

}
