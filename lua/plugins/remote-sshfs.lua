return {
  "nosduco/remote-sshfs.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  opts = {
    -- Refer to the configuration section below
    -- or leave empty for defaults
    ui = { picker = "fzf-lua" },
  },
  config = function(_, opts)
    require("remote-sshfs").setup(opts)
    require("telescope").load_extension('remote-sshfs')
    require("remote-sshfs").callback.on_connect_success:add(function(host, mount_dir)
      vim.notify("已連線：" .. host .. " → " .. mount_dir)
    end)
  end,
  keys = {
    { '<leader>rc', function() require("remote-sshfs.api").connect() end,    desc = "SSHFS connect" },
    { '<leader>rd', function() require("remote-sshfs.api").disconnect() end, desc = "SSHFS disconnect" },
    { '<leader>re', function() require("remote-sshfs.api").edit() end,       desc = "SSHFS edit" },
    {
      '<leader>ff',
      function()
        local c = require("remote-sshfs.connections")
        if c.is_connected() then
          require("remote-sshfs.api").find_files()
        else
          require("fzf-lua").files()
        end
      end,
      desc = "Find files"
    },
    {
      '<leader>fg',
      function()
        local c = require("remote-sshfs.connections")
        if c.is_connected() then
          require("remote-sshfs.api").live_grep()
        else
          require("fzf-lua").live_grep()
        end
      end,
      desc = "Live grep"
    },
  },
}
