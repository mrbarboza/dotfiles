local M = {}

function M.servers()
  return {
    pyright = {},
    ruff = {
      init_options = {
        settings = {
          logLevel = "error",
        },
      },
    },
  }
end

function M.setup() end

function M.on_attach(client, _bufnr)
  if client.name == "ruff" then
    client.server_capabilities.hoverProvider = false
  end
end

return M
