local M = {}

function M.setup()
  require("todo-comments").setup({})

  vim.keymap.set("n", "]t", function()
    require("todo-comments").jump_next()
  end, { desc = "Next Todo Comment" })
  vim.keymap.set("n", "[t", function()
    require("todo-comments").jump_prev()
  end, { desc = "Previous Todo Comment" })
  vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Todo" })
  vim.keymap.set("n", "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", { desc = "Todo/Fix/Fixme" })
  vim.keymap.set("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>", { desc = "Todo (Trouble)" })
  vim.keymap.set("n", "<leader>xT", function()
    require("trouble").open({
      mode = "todo",
      filter = { tag = { "TODO", "FIX", "FIXME" } },
    })
  end, { desc = "Todo/Fix/Fixme (Trouble)" })
end

return M
