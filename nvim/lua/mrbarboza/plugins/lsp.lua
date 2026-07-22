local M = {}

local diagnostic_icons = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}

local lsp_util = require("mrbarboza.util.lsp")

local default_keys = {
  { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
  { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
  { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
  { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
  { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
  { "K", vim.lsp.buf.hover, desc = "Hover" },
  { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
  { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, has = "codeAction" },
  { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "x" }, has = "codeLens" },
  { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh Codelens", mode = "n", has = "codeLens" },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
  { "<leader>cR", lsp_util.rename_file, desc = "Rename File" },
  { "<leader>cA", lsp_util.source_action, desc = "Source Action", has = "codeAction" },
  { "<leader>co", lsp_util.organize_imports, desc = "Organize Imports", has = "codeAction" },
  { "<leader>cf", function()
    require("conform").format({ async = false, timeout_ms = 3000 })
  end, desc = "Format" },
  { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
  { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
  { "]]", lsp_util.next_reference, desc = "Next Reference", has = "documentHighlight" },
  { "[[", lsp_util.prev_reference, desc = "Prev Reference", has = "documentHighlight" },
  { "<A-n>", lsp_util.next_reference, desc = "Next Reference", has = "documentHighlight" },
  { "<A-p>", lsp_util.prev_reference, desc = "Prev Reference", has = "documentHighlight" },
  { "<leader>gai", "<cmd>lua vim.lsp.buf.incoming_calls()<cr>", desc = "C[a]lls Incoming", has = "callHierarchy" },
  { "<leader>gao", "<cmd>lua vim.lsp.buf.outgoing_calls()<cr>", desc = "C[a]lls Outgoing", has = "callHierarchy" },
}

local function map_keys(keys, buffer)
  for _, key in ipairs(keys) do
    local modes = key.mode or "n"
    if type(modes) == "string" then
      modes = { modes }
    end
    local opts = {
      buffer = buffer,
      desc = key.desc,
      silent = true,
      nowait = key.nowait,
    }
    for _, mode in ipairs(modes) do
      vim.keymap.set(mode, key[1], key[2], opts)
    end
  end
end

local function on_attach(client, bufnr)
  map_keys(default_keys, bufnr)
  require("mrbarboza.plugins.lang").on_attach(client, bufnr)
end

function M.setup()
  vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    },
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = diagnostic_icons.Error,
        [vim.diagnostic.severity.WARN] = diagnostic_icons.Warn,
        [vim.diagnostic.severity.HINT] = diagnostic_icons.Hint,
        [vim.diagnostic.severity.INFO] = diagnostic_icons.Info,
      },
    },
  })

  vim.lsp.config("*", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    on_attach = on_attach,
  })

  require("mrbarboza.plugins.lang").setup()

  local servers = require("mrbarboza.plugins.lang").servers()

  require("mason").setup({
    ensure_installed = vim.list_extend(vim.tbl_keys(servers), {
      "stylua",
      "shfmt",
      "prettier",
      "markdownlint-cli2",
      "markdown-toc",
      "hadolint",
    }),
  })

  for name, opts in pairs(servers) do
    vim.lsp.config(name, opts)
  end

  require("mason-lspconfig").setup({
    ensure_installed = vim.tbl_keys(servers),
    automatic_enable = true,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("mrbarboza_lsp_inlay", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
      end
    end,
  })
end

return M
