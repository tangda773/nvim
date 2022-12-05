-- Run setup and specify two custom build engines
require("texmagic").setup({
  engines = {
    pdflatex = { -- This has the same name as a default engine but would
      -- be preferred over the same-name default if defined
      executable = "latexmk",
      args = {
        "-pdflatex",
        "-interaction=nonstopmode",
        "-synctex=1",
        "-outdir=.build",
        "-pv",
        "%f",
      },
    },
    xelatex = {
      executable = "latexmk",
      args = {
        "-xelatex",
        "-pdfxe",
        "-interaction=nonstopmode",
        "-synctex=1",
        "-pv",
        "%f",
      },
    },
    lualatex = { -- This is *not* one of the defaults, but it can be
      -- called via magic comment if defined here
      executable = "latexmk",
      args = {
        "-pdflua",
        "-interaction=nonstopmode",
        "-synctex=1",
        "-pv",
        "%f",
      },
    },
  },
})
