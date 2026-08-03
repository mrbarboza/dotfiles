-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Transparent background, follows wezterm window_background_opacity/blur (see wezterm/wezterm.lua)
local function set_transparency()
  local groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "FloatBorder",
    "SignColumn",
    "LineNr",
    "EndOfBuffer",
    "MsgArea",
    "TelescopeNormal",
    "TelescopeBorder",
    "NeoTreeNormal",
    "NeoTreeNormalNC",
    "WhichKeyFloat",
  }
  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("transparency", { clear = true }),
  pattern = "*",
  callback = set_transparency,
})

set_transparency()
