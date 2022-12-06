vim.g.vimtex_compiler_latexmk = {
  build_dir = "",
  callback = 1,
  continuous = 1,
  executable = "latexmk",
  hooks = {},
  options = {
    "-verbose",
    "-file-line-error",
    "-synctex=1",
    "-interaction=nonstopmode",
  },
}
vim.g.vimtex_compiler_latexmk_engines = {
  ["_"] = "-pdf",
  ["pdfdvi"] = "-pdfdvi",
  ["pdfps"] = "-pdfps",
  ["pdflatex"] = "-pdf",
  ["luatex"] = "-lualatex",
  ["lualatex"] = "-lualatex",
  ["xelatex"] = "-xelatex",
  ["context (pdftex)"] = "-pdf -pdflatex=texexec",
  ["context (luatex)"] = "-pdf -pdflatex=context",
  ["context (xetex)"] = "-pdf -pdflatex=''texexec --xtx''",
}

vim.g.tex_flavor = "latex"
vim.g.vimtex_view_general_viewer = "SumatraPDF"
vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
