return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = {
      variant = "moon", -- matches wezterm rose-pine-moon + tmux
      dark_variant = "moon",
      styles = {
        transparency = true, -- let wezterm's window opacity show through
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
