return {
  "luukvbaal/statuscol.nvim",
  config = function()
    vim.opt.fillchars = {
      foldclose = "", -- foldclose
      foldopen = "", -- foldopen
      foldsep = " " -- foldsep
    }
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      -- configuration goes here, for example:
      relculright = true,
      segments = {
        { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
        {
          sign = { namespace = { "diagnostic" }, maxwidth = 2, auto = true },
          click = "v:lua.ScSa"
        },
        {
          sign = { name = { ".*" }, text = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
          click = "v:lua.ScSa"
        },
        { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa", },
      },
    })
  end,
}
