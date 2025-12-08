return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = function()
      local keys = {
        {
          '<leader>hh',
          function()
            require('harpoon'):list():add()
          end,
          desc = '[H]arpoon File',
        },
        {
          '<leader>hm',
          function()
            local harpoon = require 'harpoon'
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = 'Harpoon Quick [M]enu',
        },
        {
          '<leader>hp',
          function()
            require('harpoon'):list():prev()
          end,
          desc = '[H]arpoon [P]revious',
        },
        {
          '<leader>hn',
          function()
            require('harpoon'):list():next()
          end,
          desc = '[H]arpoon [N]ext',
        },
      }

      for i = 1, 9 do
        table.insert(keys, {
          '<leader>' .. i,
          function()
            require('harpoon'):list():select(i)
          end,
          desc = 'Harpoon to File ' .. i,
        })
      end
      return keys
    end,
  },
}
