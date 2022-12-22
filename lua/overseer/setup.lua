require("overseer").setup({
  templates = { "builtin", "user.cpp_build", "user.cmake_build", "user.cmake_generate", "user.run_script", "user.python_build" },
})
