local root = require("mrbarboza.util.root")

local M = {}

local function toggle(dir)
  if vim.bo.filetype == "oil" then
    require("oil").close()
  else
    require("oil").open(dir)
  end
end

function M.setup()
  require("oil").setup({
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
    },
  })

  -- LazyVim explorer keymaps (see lazyvim/plugins/extras/editor/neo-tree.lua)
  vim.keymap.set("n", "<leader>fe", function()
    toggle(root.dir())
  end, { desc = "Explorer Oil (Root Dir)" })

  vim.keymap.set("n", "<leader>fE", function()
    toggle(vim.fn.getcwd())
  end, { desc = "Explorer Oil (cwd)" })

  vim.keymap.set("n", "<leader>e", function()
    toggle(root.dir())
  end, { desc = "Explorer Oil (Root Dir)" })

  vim.keymap.set("n", "<leader>E", function()
    toggle(vim.fn.getcwd())
  end, { desc = "Explorer Oil (cwd)" })

  vim.keymap.set("n", "-", function()
    require("oil").open(vim.fn.expand("%:p:h"))
  end, { desc = "Open Parent Directory" })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("oil_start_directory", { clear = true }),
    desc = "Start Oil with directory",
    once = true,
    callback = function()
      if package.loaded["oil"] then
        return
      end
      local stat = vim.uv.fs_stat(vim.fn.argv(0))
      if stat and stat.type == "directory" then
        require("oil").open(vim.fn.argv(0))
      end
    end,
  })
end

return M
