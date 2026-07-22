local M = {}

function M.servers()
  return {
    vtsls = {
      settings = {
        complete_function_calls = true,
        vtsls = {
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = true,
        },
        typescript = {
          updateImportsOnFileMove = { enabled = "always" },
          suggest = { completeFunctionCalls = true },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
      },
    },
  }
end

function M.setup() end

function M.on_attach(client, bufnr)
  if client.name ~= "vtsls" then
    return
  end

  local function map(lhs, fn, desc)
    vim.keymap.set("n", lhs, fn, { buffer = bufnr, desc = desc, silent = true })
  end

  map("gD", function()
    local win = vim.api.nvim_get_current_win()
    local params = vim.lsp.util.make_position_params(win, "utf-16")
    client:exec_cmd({
      command = "typescript.goToSourceDefinition",
      arguments = { params.textDocument.uri, params.position },
    })
  end, "Goto Source Definition")

  map("gR", function()
    client:exec_cmd({
      command = "typescript.findAllFileReferences",
      arguments = { vim.uri_from_bufnr(bufnr) },
    })
  end, "Goto File References")
end

return M
