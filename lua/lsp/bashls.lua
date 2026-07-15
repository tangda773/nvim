return {
  settings = {
    bashIde = {
      -- 預設 upstream 是 "**/*@(.sh|.inc|.bash|.command)"
      globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
    },
  }
}
