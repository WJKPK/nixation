local wk = require("which-key")

wk.setup({})
wk.add({
  -- Normal mode mappings
  { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Toggle term" },
  { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
  { "<leader>/", "<cmd>Telescope live_grep_args<cr>", desc = "Live Grep" },
  { "<leader>w", "<cmd>Telescope grep_string<cr>", desc = "String Grep" },
  { "<leader>w", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", desc = "String Grep" },
  { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find File" },
  { "<leader>g", group = "Git / VCS" },
  { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame line" },
  { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Commit" },
  { "<leader>gs", "<cmd>Neogit kind=split<cr>", desc = "Staging" },
  { "<leader>l", group = "LSP" },
  { "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Goto implementation" },
  { "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Goto definition" },
  { "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename under cursor" },
  { "<leader>lr", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "Find all references" },
  { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code action" },
  { "<leader>p", "\"+p", desc = "Paste from clipboard" },
  { "<leader>P", "\"+P", desc = "Paste from clipboard before cursor" },
  { "<leader>y", "\"+y", desc = "Yank to clipboard" },
  { "<C-s>", "<cmd>vs<cr>", desc = "Vertical Split" },
  { "<leader>e", "<cmd>Yazi<cr>", desc = "Yazi toggle" },
  { "<leader>s", "<cmd>Yazi cwd<cr>", desc = "Yazi source directory" },
  { "<M-j>", "<cmd>cnext<cr>", desc = "Next quickfix list item" },
  { "<M-k>", "<cmd>cprev<cr>", desc = "Previous quickfix list item" },

  -- Visual mode mapping
  { "<leader>y", "\"+y", desc = "Yank to clipboard", mode = "v" },
})
