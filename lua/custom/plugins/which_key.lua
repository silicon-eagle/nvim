return {
  {                   -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = "<Up> ",
          Down = "<Down> ",
          Left = "<Left> ",
          Right = "<Right> ",
          C = "<C-…> ",
          M = "<M-…> ",
          D = "<D-…> ",
          S = "<S-…> ",
          CR = "<CR> ",
          Esc = "<Esc> ",
          ScrollWheelDown = "<ScrollWheelDown> ",
          ScrollWheelUp = "<ScrollWheelUp> ",
          NL = "<NL> ",
          BS = "<BS> ",
          Space = "<Space> ",
          Tab = "<Tab> ",
          F1 = "<F1>",
          F2 = "<F2>",
          F3 = "<F3>",
          F4 = "<F4>",
          F5 = "<F5>",
          F6 = "<F6>",
          F7 = "<F7>",
          F8 = "<F8>",
          F9 = "<F9>",
          F10 = "<F10>",
          F11 = "<F11>",
          F12 = "<F12>",
        },
      },

      -- Document existing key chains
      spec = {
        mode = { "n", "x" },
        { "<leader>b",  group = "buffers" },
        { "<leader>c",  group = "code" },
        { "<leader>d",  group = "debug" },
        { "<leader>dt", group = "debug/test" },
        { "<leader>f",  group = "file" },
        { "<leader>g",  group = "git" },
        { "<leader>h",  group = "harpoon" },
        { "<leader>l",  group = "lazy" },
        { "<leader>m",  group = "minimap" },
        { "<leader>n",  group = "notifications" },
        { "<leader>p",  group = "pytest" },
        { "<leader>o",  group = "open overview" },
        { "<leader>q",  group = "quit/session" },
        { "<leader>s",  group = "search" },
        { "<leader>t",  group = "terminal" },
        { "<leader>u",  group = "ui" },
        { "<leader>x",  group = "diagnostics/quickfix" },
        { "[",          group = "prev" },
        { "]",          group = "next" },
        { "g",          group = "goto" },
        { "gs",         group = "surround" },
        { "z",          group = "fold" },
        {
          "<leader>b",
          group = "buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        {
          "<leader>w",
          group = "windows",
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
      },
    },
  },
}
