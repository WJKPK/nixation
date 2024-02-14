vim.g.mapleader = " "

local wk = require("which-key")

wk.setup({})

wk.register({
  ["<leader>"] = {
    t = { "<cmd>ToggleTerm<cr>", "Toggle term" },
    b = { "<cmd>Telescope buffers<cr>", "Buffers" },
    ["/"] = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
    w = { "<cmd>Telescope grep_string<cr>", "String Grep" },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    g = {
      name = "Git / VCS",
      b = { "<cmd>Gitsigns blame_line<cr>", "Blame line" },
      c = { "<cmd>Neogit commit<cr>", "Commit" },
      s = { "<cmd>Neogit kind=split<cr>", "Staging" },
    },
    l = {
      name = "LSP",
      d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Goto definition"},
      D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Goto declaration" },
    },
      p = { "\"+p", "Paste from clipboard" },
      P = { "\"+P", "Paste from clipboard before cursor" },
      y = { "\"+y", "Yank to clipboard" },
    },
  g = {
    l = { "$", "Line end" },
    h = { "0", "Line start" },
    s = { "^", "First non-blank in line" },
    e = { "G", "Bottom" },
  },
})
