local M = {}

function M.setup()
  -- alpha replaces the built-in intro screen
  vim.opt.shortmess:append("I")

  -- rose-pine defines AlphaHeader/AlphaButtons/AlphaShortcut/AlphaFooter
  local dashboard = require("alpha.themes.dashboard")

  dashboard.section.header.val = require("mrbarboza.art.neovim-mark")
  dashboard.section.header.opts.hl = "AlphaHeader"

  dashboard.section.buttons.val = {
    dashboard.button("f", "󰈞 Find file", "<cmd> lua require('mrbarboza.util.pick').open('files') <cr>"),
    dashboard.button("n", "󰈔 New file", [[<cmd> ene <BAR> startinsert <cr>]]),
    dashboard.button("r", "󰋚 Recent files", "<cmd> lua require('mrbarboza.util.pick').open('oldfiles') <cr>"),
    dashboard.button("g", "󰱽 Find text", "<cmd> lua require('mrbarboza.util.pick').open('live_grep') <cr>"),
    dashboard.button("c", "󰒓 Config", string.format(
      "<cmd> lua require('telescope.builtin').find_files({ cwd = %q }) <cr>",
      vim.fn.stdpath("config")
    )),
    dashboard.button("s", "󰑐 Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
    dashboard.button("q", "󰗼 Quit", "<cmd> qa <cr>"),
  }

  for _, button in ipairs(dashboard.section.buttons.val) do
    button.opts.hl = "AlphaButtons"
    button.opts.hl_shortcut = "AlphaShortcut"
  end

  dashboard.section.buttons.opts.hl = "AlphaButtons"
  dashboard.section.footer.opts.hl = "AlphaFooter"

  local v = vim.version()
  dashboard.section.footer.val = "󰚩 Neovim " .. string.format("%d.%d.%d", v.major, v.minor, v.patch)

  dashboard.opts.layout = {
    {
      type = "group",
      opts = { position = "v_center" },
      val = {
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        dashboard.section.footer,
      },
    },
  }

  require("alpha").setup(dashboard.opts)
end

return M
