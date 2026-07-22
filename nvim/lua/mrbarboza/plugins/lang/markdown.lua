local M = {}

function M.servers()
  return {
    marksman = {},
  }
end

function M.setup()
  vim.filetype.add({ extension = { mdx = "markdown.mdx" } })
end

function M.on_attach(_client, _bufnr) end

function M.conform()
  return {
    formatters_by_ft = {
      markdown = { "prettier" },
      ["markdown.mdx"] = { "prettier" },
    },
  }
end

function M.lint()
  return { markdown = { "markdownlint-cli2" } }
end

function M.keymaps()
  return {
    { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    {
      "<leader>cT",
      function()
        require("conform").format({ formatters = { "markdown-toc" }, async = false, timeout_ms = 3000 })
      end,
      desc = "Update Markdown TOC",
    },
    {
      "<leader>cL",
      function()
        require("conform").format({ formatters = { "markdownlint-cli2" }, async = false, timeout_ms = 3000 })
      end,
      desc = "Fix Markdown Lint",
    },
  }
end

return M
