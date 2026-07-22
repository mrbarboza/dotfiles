local M = {}

M.plugins = {
  -- theme / navigation (existing)
  { name = "rose-pine", src = "https://github.com/rose-pine/neovim" },
  { name = "vim-tmux-navigator", src = "https://github.com/christoomey/vim-tmux-navigator" },
  { name = "oil.nvim", src = "https://github.com/stevearc/oil.nvim" },
  { name = "gitsigns.nvim", src = "https://github.com/lewis6991/gitsigns.nvim" },
  { name = "plenary.nvim", src = "https://github.com/nvim-lua/plenary.nvim" },
  { name = "lazygit.nvim", src = "https://github.com/kdheepak/lazygit.nvim" },
  { name = "which-key.nvim", src = "https://github.com/folke/which-key.nvim" },

  -- LSP
  { name = "mason.nvim", src = "https://github.com/mason-org/mason.nvim" },
  { name = "mason-lspconfig.nvim", src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { name = "nvim-lspconfig", src = "https://github.com/neovim/nvim-lspconfig" },

  -- treesitter
  { name = "nvim-treesitter", src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { name = "nvim-treesitter-textobjects", src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  { name = "nvim-ts-autotag", src = "https://github.com/windwp/nvim-ts-autotag" },

  -- format / lint
  { name = "conform.nvim", src = "https://github.com/stevearc/conform.nvim" },
  { name = "nvim-lint", src = "https://github.com/mfussenegger/nvim-lint" },

  -- picker
  { name = "telescope.nvim", src = "https://github.com/nvim-telescope/telescope.nvim" },
  { name = "telescope-fzf-native.nvim", src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },

  -- UI
  { name = "alpha-nvim", src = "https://github.com/goolord/alpha-nvim" },
  { name = "mini.icons", src = "https://github.com/nvim-mini/mini.icons" },
  { name = "bufferline.nvim", src = "https://github.com/akinsho/bufferline.nvim" },
  { name = "lualine.nvim", src = "https://github.com/nvim-lualine/lualine.nvim" },
  { name = "nvim-notify", src = "https://github.com/rcarriga/nvim-notify" },
  { name = "noice.nvim", src = "https://github.com/folke/noice.nvim" },
  { name = "nui.nvim", src = "https://github.com/MunifTanjim/nui.nvim" },

  -- editing / completion
  { name = "nvim-cmp", src = "https://github.com/hrsh7th/nvim-cmp" },
  { name = "cmp-nvim-lsp", src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { name = "cmp-buffer", src = "https://github.com/hrsh7th/cmp-buffer" },
  { name = "cmp-path", src = "https://github.com/hrsh7th/cmp-path" },
  { name = "mini.pairs", src = "https://github.com/nvim-mini/mini.pairs" },
  { name = "mini.comment", src = "https://github.com/nvim-mini/mini.comment" },
  { name = "mini.surround", src = "https://github.com/nvim-mini/mini.surround" },
  { name = "yanky.nvim", src = "https://github.com/gbprod/yanky.nvim" },

  -- editor extras
  { name = "harpoon", src = "https://github.com/ThePrimeagen/harpoon" },
  { name = "trouble.nvim", src = "https://github.com/folke/trouble.nvim" },
  { name = "todo-comments.nvim", src = "https://github.com/folke/todo-comments.nvim" },
  { name = "persistence.nvim", src = "https://github.com/folke/persistence.nvim" },

  -- languages
  { name = "SchemaStore.nvim", src = "https://github.com/b0o/SchemaStore.nvim" },
  { name = "markdown-preview.nvim", src = "https://github.com/iamcco/markdown-preview.nvim" },
}

M.nubank_plugins = {
  -- LazyVim lang.clojure extra
  { name = "conjure", src = "https://github.com/Olical/conjure" },
  { name = "cmp-conjure", src = "https://github.com/PaterJason/cmp-conjure" },
  { name = "nvim-paredit", src = "https://github.com/julienvincent/nvim-paredit" },
  { name = "baleia.nvim", src = "https://github.com/m00qek/baleia.nvim" },
}

local function all_plugins()
  local plugins = vim.deepcopy(M.plugins)
  if require("mrbarboza.nubank").enabled() then
    vim.list_extend(plugins, M.nubank_plugins)
  end
  return plugins
end

local function setup_theme()
  require("rose-pine").setup({
    variant = "moon",
    styles = {
      transparency = true,
    },
  })
  vim.cmd.colorscheme("rose-pine-moon")
  require("mrbarboza.transparency").set_transparency()
end

local function setup_tmux_navigator()
  vim.g.tmux_navigator_preserve_zoom = 1
  vim.cmd.packadd("vim-tmux-navigator")
end

local function setup_build_hooks()
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      if ev.data.kind ~= "install" then
        return
      end
      local name = ev.data.spec.name
      local path = ev.data.path

      if name == "telescope-fzf-native.nvim" then
        vim.fn.system({ "make", "-C", path })
      elseif name == "markdown-preview.nvim" then
        vim.fn.system({ "bash", "-lc", string.format("cd %q/app && npm install", path) })
      end
    end,
  })
end

local function setup_plugins()
  require("mrbarboza.plugins.alpha").setup()
  require("mrbarboza.plugins.oil").setup()
  require("mrbarboza.plugins.git").setup()
  require("mrbarboza.plugins.ui").setup()
  require("mrbarboza.plugins.treesitter").setup()
  require("mrbarboza.plugins.lsp").setup()
  require("mrbarboza.plugins.conform").setup()
  require("mrbarboza.plugins.lint").setup()
  require("mrbarboza.plugins.editing").setup()
  require("mrbarboza.plugins.cmp").setup()
  require("mrbarboza.plugins.telescope").setup()
  require("mrbarboza.plugins.harpoon").setup()
  require("mrbarboza.plugins.trouble").setup()
  require("mrbarboza.plugins.todo-comments").setup()
  require("mrbarboza.plugins.persistence").setup()
  require("mrbarboza.plugins.which-key").setup()
  require("mrbarboza.nubank").setup()
end

function M.setup()
  local mason_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin")
  if vim.fn.isdirectory(mason_bin) == 1 then
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
  end

  vim.g.mapleader = " "

  setup_build_hooks()

  vim.pack.add(vim.iter(all_plugins()):map(function(p)
    return { src = p.src, name = p.name }
  end):totable())

  setup_theme()
  setup_tmux_navigator()
  setup_plugins()
end

return M
