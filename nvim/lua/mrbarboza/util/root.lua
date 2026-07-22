local M = {}

function M.dir()
  local path = vim.api.nvim_buf_get_name(0)
  if path ~= "" then
    return vim.fs.root(0, { ".git", ".hg", ".svn" }) or vim.fn.getcwd()
  end
  return vim.fs.root(vim.fn.getcwd(), { ".git", ".hg", ".svn" }) or vim.fn.getcwd()
end

function M.git()
  local root = M.dir()
  local git_root = vim.fs.find(".git", { path = root, upward = true })[1]
  return git_root and vim.fn.fnamemodify(git_root, ":h") or root
end

return M
