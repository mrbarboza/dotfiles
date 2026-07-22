local M = {}

local function notify(name, state)
  vim.notify(string.format("%s: %s", name, state and "ON" or "OFF"), vim.log.levels.INFO)
end

function M.option(name, opts)
  opts = opts or {}
  local off = opts.off
  local on = opts.on
  if off == nil and on == nil then
    off = false
    on = true
  end
  local label = opts.name or name
  local current = vim.o[name]
  if off ~= nil and current == off then
    vim.o[name] = on
    notify(label, true)
  else
    vim.o[name] = off
    notify(label, false)
  end
end

function M.diagnostics()
  local enabled = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not enabled)
  notify("Diagnostics", not enabled)
end

function M.inlay_hints()
  if not vim.lsp.inlay_hint then
    return
  end
  local buf = vim.api.nvim_get_current_buf()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
  notify("Inlay Hints", not enabled)
end

function M.treesitter()
  local buf = vim.api.nvim_get_current_buf()
  if vim.treesitter.highlighter.active[buf] then
    vim.treesitter.stop()
    notify("Treesitter Highlight", false)
  else
    vim.treesitter.start()
    notify("Treesitter Highlight", true)
  end
end

function M.format_on_save(global)
  if global then
    vim.g.autoformat_enabled = not (vim.g.autoformat_enabled ~= false)
    notify("Auto Format (Global)", vim.g.autoformat_enabled)
  else
    local enabled = vim.b.autoformat_enabled ~= false and vim.g.autoformat_enabled ~= false
    vim.b.autoformat_enabled = not enabled
    notify("Auto Format (Buffer)", vim.b.autoformat_enabled)
  end
end

return M
