require("neogen").setup({
  enabled = true,
  languages = {
    ["lua.ldoc"] = require("neogen.configurations.lua"),
    ["cpp.doxygen"] = require("neogen.configurations.cpp"),
    ["c.doxygen"] = require("neogen.configurations.c"),
    ["sh.google_bash"] = require("neogen.configurations.sh"),
    ["python_google_docstrings"] = require("neogen.configurations.python"),
    ["rust.rustdoc"] = require("neogen.configurations.rust"),
  },
  snippet_engine = "luasnip",
})
