-- Load the dashboard-nvim plugin and customize it for coding productivity
local dashboard = require("dashboard")

event = 'VimEnter'
dashboard.setup {
  config = {
    header =  {
    [[           ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖         ]],
    [[           ▜███▙       ▜███▙  ▟███▛         ]],
    [[            ▜███▙       ▜███▙▟███▛          ]],
    [[             ▜███▙       ▜██████▛           ]],
    [[      ▟█████████████████▙ ▜████▛     ▟▙     ]],
    [[     ▟███████████████████▙ ▜███▙    ▟██▙    ]],
    [[            ▄▄▄▄▖           ▜███▙  ▟███▛    ]],
    [[           ▟███▛             ▜██▛ ▟███▛     ]],
    [[          ▟███▛               ▜▛ ▟███▛      ]],
    [[ ▟███████████▛                  ▟██████████▙]],
    [[ ▜██████████▛                  ▟███████████▛]],
    [[       ▟███▛ ▟▙               ▟███▛         ]],
    [[      ▟███▛ ▟██▙             ▟███▛          ]],
    [[     ▟███▛  ▜███▙           ▝▀▀▀▀           ]],
    [[     ▜██▛    ▜███▙ ▜██████████████████▛     ]],
    [[      ▜▛     ▟████▙ ▜████████████████▛      ]],
    [[            ▟██████▙       ▜███▙            ]],
    [[           ▟███▛▜███▙       ▜███▙           ]],
    [[          ▟███▛  ▜███▙       ▜███▙          ]],
    },
    shortcut = {
      {
        icon = ' ',
        icon_hl = '@variable',
        desc = 'Files',
        group = 'Label',
        action = 'Telescope find_files',
        key = 'f',
      },
      {
        desc = ' Grep',
        action = 'Telescope live_grep',
        key = 'g',
      },
      {
        desc = ' Manpages',
        action = 'Telescope man_pages',
        key = 'm',
      },
    },
  }
}
