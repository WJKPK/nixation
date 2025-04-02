local telescope = require('telescope')
local actions = require('telescope.actions')
local lga_actions = require("telescope-live-grep-args.actions")
local leap = require('leap')

vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true })

vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true })
vim.api.nvim_set_keymap("n", "n", "nzzzv", { noremap = true })
vim.api.nvim_set_keymap("n", "N", "Nzzzv", { noremap = true })

leap.add_default_mappings()
local function center_buffer()
  vim.cmd('normal! zz')
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'LeapLeave',
  callback = function()
    center_buffer()
  end,
})

telescope.setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
      -- define mappings, e.g.
      mappings = { -- extend mappings
        i = {
          -- freeze the current list and start a fuzzy search in the frozen list
          ["<C-space>"] = actions.to_fuzzy_refine,
          ["<C-w>"] = lga_actions.quote_prompt(),
          ["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        },
      },
      -- ... also accepts theme settings, for example:
      -- theme = "dropdown", -- use dropdown theme
      -- theme = { }, -- use own theme spec
      -- layout_config = { mirror=true }, -- mirror preview pane
    }
  },
  defaults = {
    mappings = {
      i = {
        ["<C-DOWN>"] = require('telescope.actions').cycle_history_next,
        ["<C-UP>"] = require('telescope.actions').cycle_history_prev,
      },
      n = i,
    },
    file_ignore_patterns = {
      "build",
      ".git",
      "result"
    },
  }
}

telescope.load_extension('fzf')
telescope.load_extension('live_grep_args')

