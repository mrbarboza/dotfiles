local M = {}

function M.servers()
  return {
    yamlls = {
      settings = {
        redhat = { telemetry = { enabled = false } },
        yaml = {
          keyOrdering = false,
          format = { enable = true },
          validate = true,
          schemaStore = { enable = false },
        },
      },
      before_init = function(_, config)
        config.settings.yaml.schemas = vim.tbl_deep_extend(
          "force",
          config.settings.yaml.schemas or {},
          require("schemastore").yaml.schemas()
        )
      end,
    },
  }
end

function M.setup()
  vim.filetype.add({
    filename = {
      [".gitlab-ci.yml"] = "yaml.gitlab",
      [".gitlab-ci.yaml"] = "yaml.gitlab",
    },
    pattern = {
      ["compose.*%.ya?ml"] = "yaml.docker-compose",
      ["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
      [".*/values%.ya?ml$"] = "yaml.helm-values",
    },
  })
end

function M.on_attach(_client, _bufnr) end

return M
