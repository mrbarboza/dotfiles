local M = {}

local ensure_installed = {
  "bash",
  "c",
  "diff",
  "dockerfile",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

function M.setup()
  local ok, ts = pcall(require, "nvim-treesitter")
  if not ok then
    return
  end

  ts.setup({
    ensure_installed = ensure_installed,
    highlight = { enable = true },
    indent = { enable = true },
  })

  pcall(function()
    vim.schedule(function()
      ts.install(ensure_installed, { summary = true })
    end)
  end)

  require("nvim-treesitter-textobjects").setup({
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
    },
  })

  require("nvim-ts-autotag").setup({})
end

return M
