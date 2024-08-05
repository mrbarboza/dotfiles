return {
    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        keys = {
            {
                "<leade>lt", ":Trouble document_diagnostics<CR>", desc = "Trouble Open Diagnostics", noremap = true, silent = true,
            },
        },
        opts = {},
    },
    {
        "folke/todo-comments.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        keys = {
            { "<leader>tt", ":TodoTrouble<CR>", desc = "TodoTrouble", noremap = true, silent = true },
            { "<leader>tc", ":TodoTelescope<CR>", desc = "TodoTelescope", noremap = true, silent = true },
        },
        opts = {},
    }
}
