local M = {}

function M.setup()
  local ok, harpoon = pcall(require, "harpoon")
  if not ok then
    return
  end

  -- harpoon2
  if type(harpoon.setup) == "function" and harpoon.list then
    harpoon:setup({ settings = { save_on_toggle = true } })

    vim.keymap.set("n", "<leader>H", function()
      harpoon:list():add()
    end, { desc = "Harpoon File" })

    vim.keymap.set("n", "<leader>h", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon Quick Menu" })

    for i = 1, 9 do
      vim.keymap.set("n", "<leader>" .. i, function()
        harpoon:list():select(i)
      end, { desc = "Harpoon to File " .. i })
    end
    return
  end

  -- harpoon v1 (master branch via vim.pack)
  local mark = require("harpoon.mark")
  local ui = require("harpoon.ui")

  vim.keymap.set("n", "<leader>H", function()
    mark.add_file()
  end, { desc = "Harpoon File" })

  vim.keymap.set("n", "<leader>h", function()
    ui.toggle_quick_menu()
  end, { desc = "Harpoon Quick Menu" })

  for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, function()
      mark.set_current_at(i)
    end, { desc = "Harpoon to File " .. i })
  end
end

return M
