local catppuccin = require("catppuccin")
local colorizer = require("colorizer")

vim.g.catppuccin_flavour = "macchiato"
vim.g.lightline = { colorscheme = "catppuccin" }
require('nvim-web-devicons').setup{}
catppuccin.setup({
  integrations = {
      leap = true,
      treesitter = true,
      cmp = true,
  }
})

colorizer.setup()
vim.cmd.colorscheme "catppuccin"

vim.cmd 'sign define DiagnosticSignError text=  linehl= texthl=DiagnosticSignError numhl='
vim.cmd 'sign define DiagnosticSignHint text=  linehl= texthl=DiagnosticSignHint numhl='
vim.cmd 'sign define DiagnosticSignInfo text=  linehl= texthl=DiagnosticSignInfo numhl='
vim.cmd 'sign define DiagnosticSignWarn text=  linehl= texthl=DiagnosticSignWarn numhl='

