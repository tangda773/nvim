-- ~/.config/nvim/lua/plugins/fzf-org.lua
return {
  {
    "0xzhzh/fzf-org.nvim",
    dependencies = {
      "ibhagwan/fzf-lua",
      "nvim-orgmode/orgmode",
    },
    keys = {
      {
        "<leader>of",
        function()
          require("fzf-org").files()
        end,
        desc = "Org files",
      },
      {
        "<leader>og",
        function()
          require("fzf-org").all_headlines()
        end,
        desc = "Org headlines",
      },
      {
        "<leader>or",
        function()
          require("fzf-org").refile()
        end,
        desc = "Org refile",
      },
    },
    config = function()
      require("fzf-org").setup({})
    end,
  },
}
