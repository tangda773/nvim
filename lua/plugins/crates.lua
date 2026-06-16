return {
    'saecki/crates.nvim',
    tag = 'stable',
    event = "BufReadPost *.toml",
    config = function()
        require('crates').setup()
    end,
}
