local map = vim.keymap.set

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- LazyGit (wired via toggleterm or snacks)
map("n", "<leader>gg", function()
  -- Prefer LazyVim's built-in lazygit integration if available
  if pcall(require, "lazyvim.util") then
    require("lazyvim.util").terminal.open({ "lazygit" }, { cwd = require("lazyvim.util").root.get(), esc_esc = false, ctrl_hjkl = false })
  else
    vim.cmd("terminal lazygit")
  end
end, { desc = "Lazygit" })

-- Clear search
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
