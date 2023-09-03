-- telescope
local telescope = require('telescope')
telescope.setup {
  defaults = { 
    file_ignore_patterns = { 
      "build",
      ".git"
    }
  }
}
telescope.load_extension('fzy_native')

require("gitsigns").setup()

-- autopairs
require('nvim-autopairs').setup{}

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
