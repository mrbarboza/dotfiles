local M = {}

function M.setup()
  require("trouble").setup({
    modes = {
      lsp = {
        win = { position = "right" },
      },
    },
  })

  vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
  vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
  vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols (Trouble)" })
  vim.keymap.set("n", "<leader>cS", "<cmd>Trouble lsp toggle<cr>", { desc = "LSP references/definitions/... (Trouble)" })
  vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
  vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

  local function trouble_qf_next(count)
    if require("trouble").is_open() then
      require("trouble").next({ mode = "last" })
    else
      vim.cmd.cnext(count)
    end
  end

  local function trouble_qf_prev(count)
    if require("trouble").is_open() then
      require("trouble").prev({ mode = "last" })
    else
      vim.cmd.cprev(count)
    end
  end

  vim.keymap.set("n", "]q", function()
    trouble_qf_next(vim.v.count1)
  end, { desc = "Next Trouble/Quickfix Item" })
  vim.keymap.set("n", "[q", function()
    trouble_qf_prev(vim.v.count1)
  end, { desc = "Previous Trouble/Quickfix Item" })
end

return M
