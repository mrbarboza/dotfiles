local M = {}

function M.setup()
  local cmp = require("cmp")

  local primary = {
    { name = "nvim_lsp" },
    { name = "path" },
  }
  local secondary = {
    { name = "buffer" },
  }

  if require("mrbarboza.nubank").enabled() and pcall(require, "cmp_conjure") then
    table.insert(secondary, 1, { name = "conjure" })
  end

  cmp.setup({
    completion = {
      completeopt = "menu,menuone,noinsert",
    },
    preselect = cmp.PreselectMode.Item,
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<C-e>"] = cmp.mapping.abort(),
    }),
    sources = cmp.config.sources(primary, secondary),
  })
end

return M
