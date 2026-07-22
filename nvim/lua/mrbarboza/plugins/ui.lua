local M = {}

local diagnostic_icons = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}

function M.setup()
  package.preload["nvim-web-devicons"] = function()
    require("mini.icons").mock_nvim_web_devicons()
    return package.loaded["nvim-web-devicons"]
  end

  require("mini.icons").setup()

  require("bufferline").setup({
    options = {
      close_command = function(n)
        vim.api.nvim_buf_delete(n, { force = true })
      end,
      right_mouse_command = function(n)
        vim.api.nvim_buf_delete(n, { force = true })
      end,
      diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      diagnostics_indicator = function(_, _, diag)
        local ret = (diag.error and diagnostic_icons.Error .. diag.error .. " " or "")
          .. (diag.warning and diagnostic_icons.Warn .. diag.warning or "")
        return vim.trim(ret)
      end,
      offsets = {
        {
          filetype = "oil",
          text = "Oil",
          highlight = "Directory",
          text_align = "left",
        },
      },
    },
  })

  vim.keymap.set("n", "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle Pin" })
  vim.keymap.set("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete Non-Pinned Buffers" })
  vim.keymap.set("n", "<leader>br", "<Cmd>BufferLineCloseRight<CR>", { desc = "Delete Buffers to the Right" })
  vim.keymap.set("n", "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Delete Buffers to the Left" })
  vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
  vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
  vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
  vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
  vim.keymap.set("n", "<leader>bj", "<cmd>BufferLinePick<cr>", { desc = "Pick Buffer" })
  vim.keymap.set("n", "[B", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer prev" })
  vim.keymap.set("n", "]B", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer next" })

  require("lualine").setup({
    options = {
      theme = "auto",
      globalstatus = vim.o.laststatus == 3,
      disabled_filetypes = { statusline = { "dashboard", "alpha" } },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = {
        {
          "diagnostics",
          symbols = diagnostic_icons,
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        "filename",
      },
      lualine_x = {
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        },
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    extensions = { "oil", "lazy", "trouble" },
  })

  require("notify").setup({
    background_colour = "#232136",
    stages = "fade_in_slide_out",
    timeout = 3000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
  })

  require("noice").setup({
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
    },
  })

  vim.keymap.set("n", "<leader>snh", function()
    require("noice").cmd("history")
  end, { desc = "Noice History" })
  vim.keymap.set("n", "<leader>snd", function()
    require("noice").cmd("dismiss")
  end, { desc = "Dismiss All Notifications" })
  vim.keymap.set("n", "<leader>sn", "<cmd>Noice<cr>", { desc = "Noice" })
  vim.keymap.set("n", "<leader>snl", function()
    require("noice").cmd("last")
  end, { desc = "Noice Last Message" })

  vim.keymap.set({ "n", "i", "s" }, "<C-d>", function()
    if require("noice.lsp").scroll(-4) then
      return "<C-d>"
    else
      return "<Down>"
    end
  end, { expr = true, desc = "Scroll Forward" })
  vim.keymap.set({ "n", "i", "s" }, "<C-u>", function()
    if require("noice.lsp").scroll(4) then
      return "<C-u>"
    else
      return "<Up>"
    end
  end, { expr = true, desc = "Scroll Backward" })
end

return M
