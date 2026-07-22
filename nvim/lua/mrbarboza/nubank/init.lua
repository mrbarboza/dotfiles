local M = {}

---@return boolean
function M.enabled()
  if vim.env.MRBARBOZA_NUBANK == "0" then
    return false
  end
  if vim.env.MRBARBOZA_NUBANK == "1" then
    return true
  end
  local nu_home = vim.env.NU_HOME or vim.fn.expand("~/dev/nu")
  return vim.fn.isdirectory(nu_home) == 1
end

---@return string
function M.nu_home()
  return vim.env.NU_HOME or vim.fn.expand("~/dev/nu")
end

function M.setup()
  if not M.enabled() then
    return
  end

  vim.env.NU_HOME = M.nu_home()
  vim.g.maplocalleader = ","

  require("mrbarboza.plugins.nubank").setup()
end

return M
