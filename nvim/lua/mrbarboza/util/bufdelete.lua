local M = {}

local function confirm_write(buf)
  if not vim.api.nvim_buf_get_option(buf, "modified") then
    return true
  end
  local choice = vim.fn.confirm("Save changes to " .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t") .. "?", "&Yes\n&No\n&Cancel")
  if choice == 1 then
    vim.api.nvim_buf_call(buf, function()
      vim.cmd.write()
    end)
    return true
  elseif choice == 2 then
    return true
  end
  return false
end

function M.delete()
  local buf = vim.api.nvim_get_current_buf()
  if not confirm_write(buf) then
    return
  end
  vim.api.nvim_buf_delete(buf, { force = true })
end

function M.delete_other()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      if confirm_write(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end
end

function M.delete_invisible()
  local visible = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    visible[vim.api.nvim_win_get_buf(win)] = true
  end
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and not visible[buf] and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      if confirm_write(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end
end

function M.delete_and_close()
  local buf = vim.api.nvim_get_current_buf()
  if not confirm_write(buf) then
    return
  end
  vim.cmd("bdelete!")
  if #vim.api.nvim_list_wins() > 1 then
    vim.cmd("close")
  end
end

return M
