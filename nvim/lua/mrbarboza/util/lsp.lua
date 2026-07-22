local M = {}

local function get_refs(bufnr, callback)
  local params = vim.lsp.util.make_position_params(0, "utf-16")
  vim.lsp.buf_request(bufnr, "textDocument/references", params, function(err, result)
    if err or not result or #result == 0 then
      return
    end
    callback(result)
  end)
end

local function jump_ref(direction)
  local bufnr = vim.api.nvim_get_current_buf()
  get_refs(bufnr, function(refs)
    local cursor = vim.api.nvim_win_get_cursor(0)
    local current = { bufnr, cursor[1], cursor[2] }
    table.sort(refs, function(a, b)
      local ar, br = a.range.start, b.range.start
      if ar.line ~= br.line then
        return ar.line < br.line
      end
      return ar.character < br.character
    end)

    local index = nil
    for i, loc in ipairs(refs) do
      local r = loc.range.start
      if r.line + 1 == current[2] and r.character == current[3] then
        index = i
        break
      end
    end

    local next_index
    if not index then
      next_index = direction > 0 and 1 or #refs
    else
      next_index = index + direction
      if next_index > #refs then
        next_index = 1
      elseif next_index < 1 then
        next_index = #refs
      end
    end

    local loc = refs[next_index]
    vim.lsp.util.show_document(loc, "utf-16", { focus = true })
  end)
end

function M.next_reference()
  jump_ref(1)
end

function M.prev_reference()
  jump_ref(-1)
end

function M.organize_imports()
  vim.lsp.buf.code_action({
    context = { only = { "source.organizeImports" } },
    apply = true,
  })
end

function M.source_action()
  vim.lsp.buf.code_action({
    context = { only = { "source" } },
  })
end

function M.rename_file()
  local old = vim.api.nvim_buf_get_name(0)
  if old == "" then
    return
  end
  local new = vim.fn.input("Rename file to: ", old)
  if new == "" or new == old then
    return
  end
  local ok, err = pcall(vim.fn.rename, old, new)
  if not ok then
    vim.notify("Rename failed: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  vim.cmd("edit " .. vim.fn.fnameescape(new))
end

return M
