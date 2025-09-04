return{
    "danymat/neogen",
    config = function()
        require("neogen").setup({
          snippet_engine = "luasnip",
        })
    end,
    ft = {"c","cpp","python","lua","rust"}
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
}
