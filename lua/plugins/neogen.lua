return{
    "danymat/neogen",
    config = function()
        require("neogen").setup({
          snippet_engine = "luasnip",
        })
        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "<Leader>nf", ":lua require('neogen').generate()<CR>", opts)
        vim.keymap.set("n", "<Leader>nc", ":lua require('neogen').generate({type='class'})<CR>", opts)
    end,
    ft = {"c","cpp","python","lua","rust"}
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
}
