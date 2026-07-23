return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "nvim-dap-ui",        words = { "dapui" } },
      },
    },
    dependencies = {
      { "mfussenegger/nvim-dap" },
      { "rcarriga/nvim-dap-ui" },
    },
  },
}
