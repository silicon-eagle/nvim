return {
  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] []
      require('mini.surround').setup()

      local map = require 'mini.map'
      map.setup {
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.diff(),
          map.gen_integration.diagnostic(),
        },
      }
      -- QOL utilities
      require('mini.map').setup( -- No need to copy this inside `setup()`. Will be used automatically.
        {
          -- Highlight integrations (none by default)
          --

          integrations = {
            map.gen_integration.builtin_search(),
            map.gen_integration.diff(),
            map.gen_integration.diagnostic(),
          },

          -- Symbols used to display data
          symbols = {
            -- Encode symbols. See `:h MiniMap.config` for specification and
            -- `:h MiniMap.gen_encode_symbols` for pre-built ones.
            -- Default: solid blocks with 3x2 resolution.
            encode = MiniMap.gen_encode_symbols.dot '4x2',

            -- Scrollbar parts for view and line. Use empty string to disable any.
            scroll_line = '█',
            scroll_view = '┃',
          },

          -- Window options
          window = {
            -- Whether window is focusable in normal way (with `wincmd` or mouse)
            focusable = false,

            -- Side to stick ('left' or 'right')
            side = 'right',

            -- Whether to show count of multiple integration highlights
            show_integration_count = true,

            -- Total width
            width = 10,

            -- Value of 'winblend' option
            winblend = 25,

            -- Z-index
            zindex = 10,
          },
        }
      )
      require('mini.cursorword').setup()

      -- Starter page
      local starter = require 'mini.starter'
      starter.setup {
        evaluate_single = true,
        items = {
          starter.sections.builtin_actions(),
          starter.sections.recent_files(5, false),
          starter.sections.recent_files(5, true),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet(),
          starter.gen_hook.indexing('all', { 'Builtin actions' }),
          starter.gen_hook.padding(3, 2),
        },
      }

      -- mini statusline
      -- local my_active_content = function()
      --   local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
      --   local git = MiniStatusline.section_git { trunc_width = 40 }
      --   local diff = MiniStatusline.section_diff { trunc_width = 75 }
      --   local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
      --   local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
      --   local filename = MiniStatusline.section_filename { trunc_width = 140 }
      --   local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
      --   local location = MiniStatusline.section_location { trunc_width = 75 }
      --   local search = MiniStatusline.section_searchcount { trunc_width = 75 }
      --
      --   return MiniStatusline.combine_groups {
      --     { hl = mode_hl,                 strings = { mode } }
      --     { hl = MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
      --     '%<', -- Mark general truncate point
      --     { hl = 'MiniStatuslineFilename', strings = { filename } },
      --     '%=', -- End left alignment
      --     { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
      --     { hl = mode_hl,                  strings = { search, location } },
      --   }
      -- end
      -- require('mini.statusline').setup { content = { active = my_active_content } }

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
