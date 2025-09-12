return {
  "nosduco/remote-sshfs.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  opts = {
    -- Refer to the configuration section below
    -- or leave empty for defaults
  },
  config = function(_, opts)
    require("remote-sshfs").setup(opts)
    require("telescope").load_extension('remote-sshfs')
    local api = require('remote-sshfs.api')
    -- vim.keymap.set('n', '<leader>rc', api.connect, { desc = "remote-sshfs connect" })
    vim.keymap.set('n', '<leader>rd', api.disconnect, { desc = "remote-sshfs disconnect" })
    vim.keymap.set('n', '<leader>re', api.edit, { desc = "remote-sshfs edit" })

    -- (optional) Override telescope find_files and live_grep to make dynamic based on if connected to host
    local builtin = require("telescope.builtin")
    local connections = require("remote-sshfs.connections")
    vim.keymap.set("n", "<leader>ff", function()
      if connections.is_connected() then
        api.find_files()
      else
        builtin.find_files()
      end
    end, { desc = "remote-sshfs find_files" })
    vim.keymap.set("n", "<leader>fg", function()
      if connections.is_connected() then
        api.live_grep()
      else
        builtin.live_grep()
      end
    end, { desc = "remote-sshfs live_grep" })
  end,
  keys = {
    {
      '<leader>rc', ':lua require("remote-sshfs.api").connect()<cr>', desc = "remote-sshfs connect", mode = "n"
    }
  }
}
