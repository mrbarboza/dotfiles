local M = {}

local bufdelete = require("mrbarboza.util.bufdelete")
local toggle = require("mrbarboza.util.toggle")

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end

function M.setup()
  -- better up/down with wrap
  vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down", silent = true })
  vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down", silent = true })
  vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up", silent = true })
  vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up", silent = true })

  -- window resize
  map("n", "<C-Up>", "<cmd>resize +2<cr>", "Increase Window Height")
  map("n", "<C-Down>", "<cmd>resize -2<cr>", "Decrease Window Height")
  map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", "Decrease Window Width")
  map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", "Increase Window Width")

  -- move lines
  map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>", "Move Down")
  map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>", "Move Up")
  map("i", "<A-j>", "<esc><cmd>execute 'move .+' . v:count1<cr>gi", "Move Down")
  map("i", "<A-k>", "<esc><cmd>execute 'move .-' . (v:count1 + 1)<cr>gi", "Move Up")
  map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<CR>gv=gv", "Move Down")
  map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<CR>gv=gv", "Move Up")

  -- buffers
  map("n", "<leader>bb", "<cmd>e #<cr>", "Switch to Other Buffer")
  map("n", "<leader>`", "<cmd>e #<cr>", "Switch to Other Buffer")
  map("n", "<leader>bd", bufdelete.delete, "Delete Buffer")
  map("n", "<leader>bo", bufdelete.delete_other, "Delete Other Buffers")
  map("n", "<leader>bi", bufdelete.delete_invisible, "Delete Invisible Buffers")
  map("n", "<leader>bD", bufdelete.delete_and_close, "Delete Buffer and Window")

  -- escape clears hlsearch (+ abort cmp in insert)
  vim.keymap.set({ "i", "n", "s" }, "<Esc>", function()
    vim.cmd("noh")
    local cmp = package.loaded.cmp and require("cmp")
    if cmp and cmp.visible() then
      cmp.abort()
      return
    end
    return "<Esc>"
  end, { expr = true, desc = "Escape and Clear hlsearch" })

  map("n", "<leader>ur", "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><cr>", "Redraw / Clear hlsearch / Diff Update")

  -- search navigation
  vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
  vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
  vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
  vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
  vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
  vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

  -- undo break-points
  map("i", ",", ",<C-g>u")
  map("i", ".", ".<C-g>u")
  map("i", ";", ";<C-g>u")

  map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr>", "Save File")
  map("n", "<leader>K", "<cmd>norm! K<cr>", "Keywordprg")

  -- comment below/above
  map("n", "gco", "o<Esc>Vcx<Esc>gccfxa<Esc>", "Add Comment Below")
  map("n", "gcO", "O<Esc>Vcx<Esc>gccfxa<Esc>", "Add Comment Above")

  map("n", "<leader>fn", "<cmd>enew<cr>", "New File")

  -- location / quickfix lists
  map("n", "<leader>xl", function()
    local ok, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
    if not ok and err then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end, "Location List")
  map("n", "<leader>xq", function()
    local ok, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
    if not ok and err then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end, "Quickfix List")

  -- diagnostics
  local diagnostic_goto = function(next, severity)
    return function()
      vim.diagnostic.jump({
        count = (next and 1 or -1) * vim.v.count1,
        severity = severity and vim.diagnostic.severity[severity] or nil,
        float = true,
      })
    end
  end
  map("n", "<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
  map("n", "]d", diagnostic_goto(true), "Next Diagnostic")
  map("n", "[d", diagnostic_goto(false), "Prev Diagnostic")
  map("n", "]e", diagnostic_goto(true, "ERROR"), "Next Error")
  map("n", "[e", diagnostic_goto(false, "ERROR"), "Prev Error")
  map("n", "]w", diagnostic_goto(true, "WARN"), "Next Warning")
  map("n", "[w", diagnostic_goto(false, "WARN"), "Prev Warning")

  -- format on save toggles
  map("n", "<leader>uf", function()
    toggle.format_on_save(true)
  end, "Toggle Auto Format (Global)")
  map("n", "<leader>uF", function()
    toggle.format_on_save(false)
  end, "Toggle Auto Format (Buffer)")

  -- option toggles
  map("n", "<leader>us", function()
    toggle.option("spell", { name = "Spelling" })
  end, "Toggle Spelling")
  map("n", "<leader>uw", function()
    toggle.option("wrap", { name = "Wrap" })
  end, "Toggle Wrap")
  map("n", "<leader>uL", function()
    toggle.option("relativenumber", { name = "Relative Number" })
  end, "Toggle Relative Number")
  map("n", "<leader>ud", toggle.diagnostics, "Toggle Diagnostics")
  map("n", "<leader>ul", function()
    toggle.option("number", { name = "Line Numbers", off = false, on = true })
  end, "Toggle Line Numbers")
  map("n", "<leader>uc", function()
    toggle.option("conceallevel", {
      name = "Conceal Level",
      off = 0,
      on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
    })
  end, "Toggle Conceal Level")
  map("n", "<leader>uA", function()
    toggle.option("showtabline", {
      name = "Tabline",
      off = 0,
      on = vim.o.showtabline > 0 and vim.o.showtabline or 2,
    })
  end, "Toggle Tabline")
  map("n", "<leader>uT", toggle.treesitter, "Toggle Treesitter Highlight")
  map("n", "<leader>ub", function()
    toggle.option("background", { name = "Dark Background", off = "light", on = "dark" })
  end, "Toggle Dark Background")
  map("n", "<leader>uh", toggle.inlay_hints, "Toggle Inlay Hints")

  map("n", "<leader>qq", "<cmd>qa<cr>", "Quit All")
  map("n", "<leader>ui", vim.show_pos, "Inspect Pos")
  map("n", "<leader>uI", function()
    vim.treesitter.inspect_tree()
    vim.api.nvim_input("I")
  end, "Inspect Tree")

  -- windows
  map("n", "<leader>-", "<C-W>s", "Split Window Below")
  map("n", "<leader>|", "<C-W>v", "Split Window Right")
  map("n", "<leader>wd", "<C-W>c", "Delete Window")

  -- indent and reselect
  map("x", "<", "<gv")
  map("x", ">", ">gv")

  vim.g.autoformat_enabled = true
end

return M
