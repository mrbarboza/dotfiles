local M = {}

function M.setup()
  local lang = require("mrbarboza.plugins.lang").conform_opts()

  require("conform").setup(vim.tbl_deep_extend("force", {
    default_format_opts = {
      timeout_ms = 3000,
      async = false,
      quiet = false,
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      lua = { "stylua" },
      sh = { "shfmt" },
    },
    formatters = {
      injected = { options = { ignore_errors = true } },
    },
  }, lang))

  vim.keymap.set({ "n", "x" }, "<leader>cF", function()
    require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
  end, { desc = "Format Injected Langs" })

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("mrbarboza_conform", { clear = true }),
    callback = function(args)
      if vim.g.autoformat_enabled == false then
        return
      end
      if vim.b[args.buf].autoformat_enabled == false then
        return
      end
      if vim.bo[args.buf].buftype ~= "" then
        return
      end
      require("conform").format({ bufnr = args.buf, async = false, timeout_ms = 3000 })
    end,
  })
end

return M
