---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
}

M.nvimtree = {
  n = {
    -- toggle
    ["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },

    -- focus
    ["<leader>n"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
  },
}

M.twilight = {
  n = {
    ["<leader>tw"] = { "<cmd>Twilight<cr>", "toggle twilight" },
  },
}

-- more keybinds!

return M
