require("overseer").setup({
  dap = false,
  strategy = "toggleterm",
  templates = {
    "builtin",
    "user.cpp_build",
    "user.c_build",
    "user.cmake_generate",
    "user.cmake_build",
    "user.run_script",
    "user.python_build",
  },
})
require("overseer").patch_dap(true);
