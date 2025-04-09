return {
    { "catppuccin/nvim", name = "catppuccin-nvim", lazy = false, priority = 1000 },
    {
      'echasnovski/mini.statusline',
      event = "VeryLazy",
      config = function()
        local MiniStatusline = require('mini.statusline')
        local show_status_line = function()
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
          local git = MiniStatusline.section_git({ trunc_width = 75 })
          local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
          local filename = MiniStatusline.section_filename({ trunc_width = 140 })
          local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
          local location = MiniStatusline.section_location({ trunc_width = 75 })
          return MiniStatusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git, diagnostics } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            { hl = mode_hl, strings = { location } },
          })
        end

        MiniStatusline.setup({
          content = {
            active = show_status_line,
            inactive = show_status_line,
          },
          use_icons = true,
          set_vim_settings = true,
        })
      end,
    },
    {
      'nvim-tree/nvim-web-devicons',
      event = "VeryLazy",
    },
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = {
        quickfile = {},
        lazygit = {},
        notifier = {},
        dashboard = {
            preset = {
              header = [[
            ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖            
            ▜███▙       ▜███▙  ▟███▛            
             ▜███▙       ▜███▙▟███▛             
              ▜███▙       ▜██████▛              
       ▟█████████████████▙ ▜████▛     ▟▙        
      ▟███████████████████▙ ▜███▙    ▟██▙       
             ▄▄▄▄▖           ▜███▙  ▟███▛       
            ▟███▛  ███╗   ██╗ ▜██▛ ▟███▛        
           ▟███▛   ████╗  ██║  ▜▛ ▟███▛         
  ▟███████████▛    ██╔██╗ ██║    ▟██████████▙   
  ▜██████████▛     ██║╚██╗██║   ▟███████████▛   
        ▟███▛ ▟▙   ██║ ╚████║  ▟███▛            
       ▟███▛ ▟██▙  ╚═╝  ╚═══╝ ▟███▛             
      ▟███▛  ▜███▙           ▝▀▀▀▀              
      ▜██▛    ▜███▙ ▜██████████████████▛        
       ▜▛     ▟████▙ ▜████████████████▛         
             ▟██████▙       ▜███▙               
            ▟███▛▜███▙       ▜███▙              
           ▟███▛  ▜███▙       ▜███▙             ]],
          },
        },
      },
    },
}
