return {
    "andrewferrier/debugprint.nvim",
    opts = {},
    -- version = "*", -- Remove if you DON'T want to use the stable version
    priority = 100,
 keys = {
    { "g?v", desc = "debugprint variable" },
    { "g?V", desc = "debugprint variable above" },
    { "g?p", desc = "debugprint plain" },
    { "g?P", desc = "debugprint plain above" },
    { "g?o", desc = "debugprint motion" },
    { "g?O", desc = "debugprint motion above" },
  },
  cmd = { "ToggleCommentDebugPrints", "DeleteDebugPrints" },
}
