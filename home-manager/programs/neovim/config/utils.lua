-- telescope
local telescope = require('telescope')
local actions = require('telescope.actions')

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

telescope.load_extension('fzy_native')

require("gitsigns").setup()
require("neogit").setup()
-- autopairs
require('nvim-autopairs').setup{}
require('gitsigns').setup{}
require("toggleterm").setup{
  direction = 'float',
  on_open = function(term)
    vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "exit<CR>", { noremap = true, silent = true })
  end,
  close_on_exit = true,
}

require('leap').add_default_mappings()
-- copy to system clipboard
vim.api.nvim_set_keymap( 'v', '<Leader>y', '"+y', {noremap = true})
vim.api.nvim_set_keymap( 'n', '<Leader>y', ':%+y<CR>', {noremap = true})

-- paste from system clipboard
vim.api.nvim_set_keymap( 'n', '<Leader>p', '"+p', {noremap = true})
vim.api.nvim_set_keymap( 'n', '<C-s>', ':vs<CR>', {noremap = true})
vim.api.nvim_set_keymap( 'n', '<Leader>e', ':NvimTreeToggle<CR>', {noremap = true})
vim.api.nvim_set_keymap( 'n', '<Leader>-', ':NvimTreeResize -10<CR>', {noremap = true})
vim.api.nvim_set_keymap( 'n', '<Leader>+', ':NvimTreeResize +10<CR>', {noremap = true})

vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true })
vim.api.nvim_set_keymap('n', '<S-w>', '<C-w>w', { noremap = true })

