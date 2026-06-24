return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    legacy_commands = false,
    workspaces = {
      { name = "personal", path = "~/notes" },
    },
    daily_notes = {
      folder = "dailies",
      date_format = "%Y-%m-%d",
      default_tags = { "daily" },
    },
    picker = { name = "fzf-lua" },
    notes_subdir = "inbox",
    new_notes_location = "notes_subdir",
    formatter = {
      enabled = false,
    },
    ui = {
      enable = false,
    },
    checkbox = {
      enable = true,
      create_new = true,
      order = { " ", "x", "-" },
    },
  },
}
