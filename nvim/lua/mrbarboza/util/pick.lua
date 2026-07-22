local root = require("mrbarboza.util.root")

local M = {}

function M.cwd()
  return root.dir()
end

---@param builtin string
---@param opts? table
function M.open(builtin, opts)
  opts = vim.tbl_extend("force", {
    cwd = opts and opts.root == false and vim.fn.getcwd() or root.dir(),
  }, opts or {})

  if opts.root == false then
    opts.cwd = vim.fn.getcwd()
  end
  opts.root = nil

  if builtin == "files" then
    if vim.fn.isdirectory(vim.fs.joinpath(opts.cwd, ".git")) == 1 then
      require("telescope.builtin").git_files(opts)
    else
      require("telescope.builtin").find_files(opts)
    end
  elseif builtin == "live_grep" then
    require("telescope.builtin").live_grep(opts)
  elseif builtin == "grep_string" then
    require("telescope.builtin").grep_string(opts)
  elseif builtin == "oldfiles" then
    require("telescope.builtin").oldfiles(opts)
  else
    require("telescope.builtin")[builtin](opts)
  end
end

---@param builtin string
---@param opts? table
function M.fn(builtin, opts)
  return function()
    M.open(builtin, opts)
  end
end

return M
