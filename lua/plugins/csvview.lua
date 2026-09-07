return {
  "hat0uma/csvview.nvim",
  ft = { "csv", "tsv" },
  opts = {
    parser = {
      comments = { "#", "//" },
      async_chunksize = 30,
      max_lookahead = 20,
      delimiter = {
        ft = {
          csv = ",",
          tsv = "\t",
        },
        fallbacks = { ",", "\t", ";", "|" },
      },
    },
    view = {
      display_mode = "border",
      min_column_width = 6,
      spacing = 2,
      header_lnum = true,
      sticky_header = {
        enabled = true,
        separator = "─",
      },
    },
    keymaps = {
      textobject_field_inner = { "if", mode = { "o", "x" } },
      textobject_field_outer = { "af", mode = { "o", "x" } },
      jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
      jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
      jump_next_row = { "<Enter>", mode = { "n", "v" } },
      jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
    },
  },
  config = function(_, opts)
    require("csvview").setup(opts)

    local function set_csv_highlights()
      vim.api.nvim_set_hl(0, "CsvViewHeaderLine", {
        fg = "#cdd6f4",
        bg = "#313244",
        bold = true,
      })

      vim.api.nvim_set_hl(0, "CsvViewDelimiter", {
        fg = "#585b70",
      })

      vim.api.nvim_set_hl(0, "CsvViewStickyHeaderSeparator", {
        fg = "#6c7086",
        bold = true,
      })
    end

    set_csv_highlights()

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("CanLogCsvHighlights", {
        clear = true,
      }),
      callback = set_csv_highlights,
    })
  end,
  cmd = {
    "CsvViewEnable",
    "CsvViewDisable",
    "CsvViewToggle",
  },
}
