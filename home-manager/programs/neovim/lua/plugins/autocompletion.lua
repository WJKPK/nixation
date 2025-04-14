return {
    {
        'echasnovski/mini.pairs',
        event = "InsertEnter",
        config = function()
            require('mini.pairs').setup()
        end
    },
    {
        'echasnovski/mini.trailspace', event = "InsertEnter"
    },
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        opts = function(_, opts)
            opts.completion = { list = { selection = { auto_insert = true }}}
            opts.keymap = {
                preset = "enter",
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
            }
        end,
    }
}
