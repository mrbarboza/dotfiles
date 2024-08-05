return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "vimdoc", "javascript", "typescript", "c", "lua", "rust",
                "jsdoc", "bash", "go", "python", "markdown", "markdown_inline",
                "css", "html", "yaml", "json", "toml",
            },
            sync_install = false,
            auto_install = true,
            indent = {
                enable = true,
            },
            autopairs = {
                enable = true,
            },
            rainbow = {
                enable = true,
                extended_mode = true,
                max_file_lines = nil,
            },
            autotag = {
                enable = true,
            },
        })
    end,
}
