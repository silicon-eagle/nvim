return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    cmd = 'CopilotChat',
    opts = function()
      local user = vim.env.USER or 'User'
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        model = 'gpt-5.1-codex',
        auto_insert_mode = true,
        headers = {
          user = '  ' .. user .. ' ',
          assistant = '  Copilot ',
          tool = '󰊳  Tool ',
        },
        window = {
          width = 0.4,
        },
      }
    end,
    keys = {
      { '<c-s>',     '<CR>', ft = 'copilot-chat', desc = 'Submit Prompt', remap = true },
      { '<leader>a', '',     desc = '+ai',        mode = { 'n', 'x' } },
      {
        '<leader>aa',
        function()
          return require('CopilotChat').toggle()
        end,
        desc = 'Toggle (CopilotChat)',
        mode = { 'n', 'x' },
      },
      {
        '<leader>am',
        function()
          return require('CopilotChat').select_model()
        end,
        desc = 'Choose [M]odel (CopilotChat)',
        mode = { 'n', 'x' },
      },
      {
        '<leader>ac',
        function()
          return require('CopilotChat').reset()
        end,
        desc = '[C]lear (CopilotChat)',
        mode = { 'n', 'x' },
      },
      {
        '<leader>aq',
        function()
          vim.ui.input({
            prompt = 'Quick Chat: ',
          }, function(input)
            if input ~= '' then
              require('CopilotChat').ask(input)
            end
          end)
        end,
        desc = '[Q]uick Chat (CopilotChat)',
        mode = { 'n', 'x' },
      },
      {
        '<leader>ap',
        function()
          require('CopilotChat').select_prompt()
        end,
        desc = '[P]rompt Actions (CopilotChat)',
        mode = { 'n', 'x' },
      },
    },
    config = function(_, opts)
      local chat = require 'CopilotChat'

      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'copilot-chat',
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
  },
}
