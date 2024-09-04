local telescope = require('telescope')
local actions = require('telescope.actions')
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
telescope.load_extension('fzy_native')
telescope.setup {
  extensions = {
  };
  defaults = {
    file_ignore_patterns = {
      "build",
      ".git"
    },
    mappings = {
      n = {
          ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
      i = {
          ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },

    }
  }
}


