return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      flavour = 'mocha',
      transparent_background = true,
      float = {
        transparent = true,
      },
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.o.winblend = 15
      vim.o.pumblend = 15
      vim.cmd.colorscheme 'catppuccin-mocha'
    end,
  },
}
