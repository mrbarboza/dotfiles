local M = {}

function M.servers()
  return {
    dockerls = {},
    docker_compose_language_service = {},
  }
end

function M.setup() end

function M.on_attach(_client, _bufnr) end

return M
