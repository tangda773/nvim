return {
  "MagicDuck/grug-far.nvim",

  opts = {
    headerMaxWidth = 80,
    transient = false,
  },

  cmd = {
    "GrugFar",
    "GrugFarWithin",
  },

  keys = {
    {
      "<leader>sr",
      function()
        require("grug-far").open({
          prefills = {
            paths = vim.fs.root(0, {
              ".git",
              "package.json",
              "go.mod",
              "Cargo.toml",
            }) or vim.fn.getcwd(),
          },
        })
      end,
      mode = "n",
      desc = "[Find] Replace in project",
    },

    {
      "<leader>sR",
      function()
        require("grug-far").open({
          prefills = {
            paths = vim.fs.root(0, {
              ".git",
              "package.json",
              "go.mod",
              "Cargo.toml",
            }) or vim.fn.getcwd(),
            search = vim.fn.expand("<cword>"),
          },
        })
      end,
      mode = "n",
      desc = "[Find] Replace word in project",
    },

    {
      "<leader>sA",
      function()
        require("grug-far").open({
          engine = "astgrep",
          prefills = {
            paths = vim.fs.root(0, {
              ".git",
              "package.json",
              "go.mod",
              "Cargo.toml",
            }) or vim.fn.getcwd(),
          },
        })
      end,
      mode = "n",
      desc = "[Find] AST search and replace",
    },

    {
      "<leader>sA",
      function()
        require("grug-far").with_visual_selection({
          engine = "astgrep",
          prefills = {
            paths = vim.fs.root(0, {
              ".git",
              "package.json",
              "go.mod",
              "Cargo.toml",
            }) or vim.fn.getcwd(),
          },
        })
      end,
      mode = "x",
      desc = "[Find] AST replace selection",
    },
  },
}
