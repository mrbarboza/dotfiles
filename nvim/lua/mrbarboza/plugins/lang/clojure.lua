local M = {}

function M.servers()
  return {
    clojure_lsp = {},
  }
end

function M.setup()
  vim.g["conjure#log#strip_ansi_escape_sequences_line_limit"] = 1

  vim.g["conjure#mapping#doc_word"] = "K"
  vim.g["conjure#mapping#def_word"] = "gd"

  require("conjure.main").main()

  require("nvim-paredit").setup({})

  local baleia = require("baleia").setup({ line_starts_at = 3 })
  vim.g.conjure_baleia = baleia

  vim.api.nvim_create_user_command("BaleiaColorize", function()
    baleia.once(vim.api.nvim_get_current_buf())
  end, { bang = true })

  vim.api.nvim_create_user_command("BaleiaLogs", baleia.logger.show, { bang = true })

  vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "conjure-log-*",
    callback = function()
      local buffer = vim.api.nvim_get_current_buf()
      vim.diagnostic.enable(false, { bufnr = buffer })
      baleia.automatically(buffer)

      vim.keymap.set({ "n", "x" }, "[c", "<CMD>call search('^; -\\+$', 'bw')<CR>", {
        silent = true,
        buffer = true,
        desc = "Previous evaluation output",
      })
      vim.keymap.set({ "n", "x" }, "]c", "<CMD>call search('^; -\\+$', 'w')<CR>", {
        silent = true,
        buffer = true,
        desc = "Next evaluation output",
      })
    end,
  })

  pcall(function()
    require("nvim-treesitter").install({ "clojure" }, { summary = true })
  end)
end

return M
