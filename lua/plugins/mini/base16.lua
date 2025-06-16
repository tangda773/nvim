require("mini.base16").setup({
    -- Table with names from `base00` to `base0F` and values being strings of
    -- HEX colors with format "#RRGGBB". NOTE: this should be explicitly
    -- supplied in `setup()`.
    palette = nil,

    -- Whether to support cterm colors. Can be boolean, `nil` (same as
    -- `false`), or table with cterm colors. See `setup()` documentation for
    -- more information.
    use_cterm = nil,

    -- Plugin integrations. Use `default = false` to disable all integrations.
    -- Also can be set per plugin (see |MiniBase16.config|).
    plugins = { default = true },
})
