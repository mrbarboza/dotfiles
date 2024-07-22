return {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    opts = {
        workspaces = {
            {
                name = "personal",
                path = "~/Developer/Personal/PunkRecords"
            },
        },
        notes_subdir = "inbox",
        new_notes_location = "notes_subdir",

        disable_frontmatter = true,
        templates = {
            subdir = "templates",
            data_format = "%Y-%m-%d",
            time_format = "%H:%M:%S",
        }
    },
}
