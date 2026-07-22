local root = require("mrbarboza.util.root")

local M = {}

local function setup_gitsigns()
  require("gitsigns").setup({
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
      end

      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next Hunk")
      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Prev Hunk")
      map("n", "]H", function()
        gs.nav_hunk("last")
      end, "Last Hunk")
      map("n", "[H", function()
        gs.nav_hunk("first")
      end, "First Hunk")
      map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
      map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
      map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
      map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
      map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
      map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
      map("n", "<leader>ghb", function()
        gs.blame_line({ full = true })
      end, "Blame Line")
      map("n", "<leader>ghB", function()
        gs.blame()
      end, "Blame Buffer")
      map("n", "<leader>ghd", gs.diffthis, "Diff This")
      map("n", "<leader>ghD", function()
        gs.diffthis("~")
      end, "Diff This ~")
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
    end,
  })

  vim.keymap.set("n", "<leader>uG", function()
    require("gitsigns").toggle_signs()
  end, { desc = "Toggle Git Signs" })
end

local function setup_lazygit()
  if vim.fn.executable("lazygit") ~= 1 then
    return
  end

  vim.cmd.packadd("lazygit.nvim")
  local lazygit = require("lazygit")

  vim.g.lazygit_use_neovim_remote = 1
  vim.g.lazygit_floating_window_winblend = 0

  -- LazyVim keymaps (see lazyvim/config/keymaps.lua)
  vim.keymap.set("n", "<leader>gg", function()
    lazygit.lazygit(root.git())
  end, { desc = "Lazygit (Root Dir)" })

  vim.keymap.set("n", "<leader>gG", function()
    lazygit.lazygit(vim.fn.getcwd())
  end, { desc = "Lazygit (cwd)" })

  vim.keymap.set("n", "<leader>gL", function()
    lazygit.lazygitlog(vim.fn.getcwd())
  end, { desc = "Git Log (cwd)" })

  vim.keymap.set("n", "<leader>gb", function()
    require("gitsigns").blame_line({ full = true })
  end, { desc = "Git Blame Line" })

  vim.keymap.set("n", "<leader>gf", function()
    lazygit.lazygitfiltercurrentfile()
  end, { desc = "Git Current File History" })

  vim.keymap.set("n", "<leader>gl", function()
    lazygit.lazygitfilter(nil, root.git())
  end, { desc = "Git Log" })

  vim.api.nvim_create_autocmd("TermClose", {
    pattern = "*lazygit*",
    callback = function()
      require("gitsigns").refresh()
    end,
  })
end

function M.setup()
  setup_gitsigns()
  setup_lazygit()
end

return M
