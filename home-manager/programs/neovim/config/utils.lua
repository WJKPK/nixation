local yazi = require("yazi");

require("markview").setup {
    config = {
        typst = true
    }
}
yazi.setup {}
require("toggleterm").setup {
  direction = 'float',
  on_open = function(term)
    vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "exit<CR>", { noremap = true, silent = true })
  end,
  close_on_exit = true,
}


