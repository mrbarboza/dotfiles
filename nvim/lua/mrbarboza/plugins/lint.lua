local M = {}

function M.setup()
  local lint = require("lint")
  local lang_linters = require("mrbarboza.plugins.lang").lint_by_ft()

  lint.linters_by_ft = lang_linters

  local function run_lint()
    local names = lint._resolve_linter_by_ft(vim.bo.filetype)
    names = vim.list_extend({}, names)
    if #names == 0 then
      vim.list_extend(names, lint.linters_by_ft["_"] or {})
    end
    vim.list_extend(names, lint.linters_by_ft["*"] or {})
    if #names > 0 then
      lint.try_lint(names)
    end
  end

  local timer = vim.uv.new_timer()
  local debounced = function()
    timer:start(100, 0, function()
      timer:stop()
      vim.schedule_wrap(run_lint)()
    end)
  end

  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("mrbarboza_lint", { clear = true }),
    callback = debounced,
  })
end

return M
