local nvim_tree = require("nvim-tree");

local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr,
        noremap = true, silent = true, nowait = true }
  end
  api.config.mappings.default_on_attach(bufnr)
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,           opts('Help'))
end

nvim_tree.setup {
   update_focused_file = {
     enable = true,
     update_root = true,
     ignore_list = {},
   },
  on_attach = my_on_attach,
}

require("toggleterm").setup{
  direction = 'float',
  on_open = function(term)
    vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "exit<CR>", { noremap = true, silent = true })
  end,
  close_on_exit = true,
}


