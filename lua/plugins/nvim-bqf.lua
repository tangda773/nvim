return {
  'kevinhwang91/nvim-bqf',
  ft='qf',
  dependencies={

    -- optional
    {'junegunn/fzf', config = function()
      vim.fn['fzf#install']()
    end
    },

    -- optional, highly recommended
    {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'}

  }
}
