local modules = {
  require("mrbarboza.plugins.lang.python"),
  require("mrbarboza.plugins.lang.typescript"),
  require("mrbarboza.plugins.lang.markdown"),
  require("mrbarboza.plugins.lang.yaml"),
  require("mrbarboza.plugins.lang.docker"),
}

if require("mrbarboza.nubank").enabled() then
  table.insert(modules, require("mrbarboza.plugins.lang.clojure"))
end

local M = {}

function M.servers()
  local servers = {
    lua_ls = {
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          completion = { callSnippet = "Replace" },
        },
      },
    },
  }

  for _, mod in ipairs(modules) do
    if mod.servers then
      servers = vim.tbl_deep_extend("force", servers, mod.servers())
    end
  end

  return servers
end

function M.setup()
  for _, mod in ipairs(modules) do
    if mod.setup then
      mod.setup()
    end
  end

  for _, mod in ipairs(modules) do
    if mod.keymaps then
      for _, key in ipairs(mod.keymaps()) do
        vim.keymap.set("n", key[1], key[2], { desc = key.desc })
      end
    end
  end
end

function M.on_attach(client, bufnr)
  for _, mod in ipairs(modules) do
    if mod.on_attach then
      mod.on_attach(client, bufnr)
    end
  end
end

function M.conform_opts()
  local opts = { formatters_by_ft = {}, formatters = {} }
  for _, mod in ipairs(modules) do
    if mod.conform then
      local c = mod.conform()
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft, c.formatters_by_ft or {})
      opts.formatters = vim.tbl_deep_extend("force", opts.formatters, c.formatters or {})
    end
  end
  return opts
end

function M.lint_by_ft()
  local linters = {}
  for _, mod in ipairs(modules) do
    if mod.lint then
      linters = vim.tbl_deep_extend("force", linters, mod.lint())
    end
  end
  linters.dockerfile = { "hadolint" }
  return linters
end

return M
