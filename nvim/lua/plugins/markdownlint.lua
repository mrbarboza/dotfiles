return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    local config = vim.fn.stdpath("config") .. "/.markdownlint-cli2.jsonc"
    opts.linters = opts.linters or {}
    opts.linters["markdownlint-cli2"] = {
      args = { "--config", config, "--" },
    }
  end,
}
