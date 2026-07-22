local M = {}

local function load_nudev()
  local nu_home = require("mrbarboza.nubank").nu_home()
  local nudev_plugin = vim.fs.joinpath(nu_home, "nudev/ides/nvim/plugin/nudev.vim")
  if vim.fn.filereadable(nudev_plugin) ~= 1 then
    return
  end

  vim.opt.rtp:prepend(vim.fs.joinpath(nu_home, "nudev/ides/nvim"))
  vim.cmd("source " .. vim.fn.fnameescape(nudev_plugin))
end

function M.setup()
  load_nudev()

  vim.g["conjure#log#strip_ansi_escape_sequences_line_limit"] = 0

  -- Nubank monorepo: treat ~/dev/nu as an extra project root for pickers
  local nu_home = require("mrbarboza.nubank").nu_home()
  if vim.fn.isdirectory(nu_home) == 1 then
    vim.g.mrbarboza_nu_home = nu_home
  end

  vim.keymap.set("n", "<leader>fn", function()
    require("telescope.builtin").find_files({ cwd = nu_home, hidden = true })
  end, { desc = "Find Files (NU_HOME)" })

  vim.keymap.set("n", "<leader>sn", function()
    require("telescope.builtin").live_grep({ cwd = nu_home })
  end, { desc = "Grep (NU_HOME)" })
end

return M
