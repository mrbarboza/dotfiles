local pick = require("mrbarboza.util.pick")

local M = {}

function M.setup()
  local actions = require("telescope.actions")
  local open_with_trouble = function(...)
    return require("trouble.sources.telescope").open(...)
  end

  require("telescope").setup({
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      mappings = {
        i = {
          ["<C-u>"] = false,
          ["<C-d>"] = false,
          ["<a-t>"] = open_with_trouble,
        },
        n = {
          ["<a-t>"] = open_with_trouble,
        },
      },
    },
  })

  pcall(require("telescope").load_extension, "fzf")

  local map = function(lhs, rhs, desc, mode)
    vim.keymap.set(mode or "n", lhs, rhs, { desc = desc })
  end

  map("<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", "Switch Buffer")
  map("<leader>/", pick.fn("live_grep"), "Grep (Root Dir)")
  map("<leader>:", "<cmd>Telescope command_history<cr>", "Command History")
  map("<leader><space>", pick.fn("files"), "Find Files (Root Dir)")
  map("<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>", "Buffers")
  map("<leader>fB", "<cmd>Telescope buffers<cr>", "Buffers (all)")
  map("<leader>fc", function()
    require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
  end, "Find Config File")
  map("<leader>ff", pick.fn("files"), "Find Files (Root Dir)")
  map("<leader>fF", pick.fn("files", { root = false }), "Find Files (cwd)")
  map("<leader>fg", "<cmd>Telescope git_files<cr>", "Find Files (git-files)")
  map("<leader>fr", "<cmd>Telescope oldfiles<cr>", "Recent")
  map("<leader>fR", pick.fn("oldfiles", { root = false }), "Recent (cwd)")
  map("<leader>gc", "<cmd>Telescope git_commits<CR>", "Commits")
  map("<leader>gs", "<cmd>Telescope git_status<CR>", "Status")
  map("<leader>gS", "<cmd>Telescope git_stash<cr>", "Git Stash")
  map('<leader>s"', "<cmd>Telescope registers<cr>", "Registers")
  map("<leader>s/", "<cmd>Telescope search_history<cr>", "Search History")
  map("<leader>sa", "<cmd>Telescope autocommands<cr>", "Auto Commands")
  map("<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer Lines")
  map("<leader>sc", "<cmd>Telescope command_history<cr>", "Command History")
  map("<leader>sC", "<cmd>Telescope commands<cr>", "Commands")
  map("<leader>sd", "<cmd>Telescope diagnostics<cr>", "Diagnostics")
  map("<leader>sD", "<cmd>Telescope diagnostics bufnr=0<cr>", "Buffer Diagnostics")
  map("<leader>sg", pick.fn("live_grep"), "Grep (Root Dir)")
  map("<leader>sG", pick.fn("live_grep", { root = false }), "Grep (cwd)")
  map("<leader>sh", "<cmd>Telescope help_tags<cr>", "Help Pages")
  map("<leader>sk", "<cmd>Telescope keymaps<cr>", "Key Maps")
  map("<leader>sm", "<cmd>Telescope marks<cr>", "Jump to Mark")
  map("<leader>sr", "<cmd>Telescope resume<cr>", "Resume")
  map("<leader>sw", pick.fn("grep_string", { word_match = "-w" }), "Word (Root Dir)")
  map("<leader>sW", pick.fn("grep_string", { root = false, word_match = "-w" }), "Word (cwd)")
  map("<leader>sw", pick.fn("grep_string"), "Selection (Root Dir)", "x")
  map("<leader>sW", pick.fn("grep_string", { root = false }), "Selection (cwd)", "x")
  map("<leader>sB", "<cmd>Telescope grep_string grep_open_files=true<cr>", "Grep Open Buffers")
  map("<leader>sH", "<cmd>Telescope highlights<cr>", "Highlights")
  map("<leader>sj", "<cmd>Telescope jumplist<cr>", "Jumps")
  map("<leader>sM", "<cmd>Telescope man_pages<cr>", "Man Pages")
  map("<leader>ss", function()
    require("telescope.builtin").lsp_document_symbols({})
  end, "Goto Symbol")
  map("<leader>sS", function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols({})
  end, "Goto Symbol (Workspace)")
end

return M
