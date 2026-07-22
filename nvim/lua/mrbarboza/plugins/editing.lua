local M = {}

function M.setup()
  require("mini.pairs").setup({
    modes = { insert = true, command = true, terminal = false },
  })

  require("mini.comment").setup()

  require("mini.surround").setup()

  require("yanky").setup({})
  vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
  vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
  vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
  vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
  vim.keymap.set("n", "<leader>p", "<Plug>(YankyPreviousEntry)", { desc = "Previous Yank" })
  vim.keymap.set("n", "<leader>P", "<Plug>(YankyNextEntry)", { desc = "Next Yank" })
end

return M
