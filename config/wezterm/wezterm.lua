local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 14.0
config.line_height = 1.1
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }

-- Rose Pine (main)
config.color_scheme = "rose-pine"
-- Built-in schemes also include "rose-pine-moon" and "rose-pine-dawn"

-- Window
config.window_background_opacity = 0.92
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500

-- Tabs
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.colors = {
  tab_bar = {
    background = "#191724",
    active_tab = {
      bg_color = "#26233a",
      fg_color = "#e0def4",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#191724",
      fg_color = "#6e6a86",
    },
    inactive_tab_hover = {
      bg_color = "#1f1d2e",
      fg_color = "#e0def4",
    },
    new_tab = {
      bg_color = "#191724",
      fg_color = "#6e6a86",
    },
    new_tab_hover = {
      bg_color = "#1f1d2e",
      fg_color = "#e0def4",
    },
  },
}

-- Keys
config.keys = {
  -- Split panes (vim-style)
  { key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = true }) },

  -- Navigate panes
  { key = "h", mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "l", mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection("Right") },
  { key = "k", mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "j", mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection("Down") },

  -- Fullscreen
  { key = "Enter", mods = "CMD", action = wezterm.action.ToggleFullScreen },
}

-- Prefer tmux for multiplexing; keep WezTerm as a clean host.
-- Uses fish from PATH (home-manager profile) so username stays portable.
config.default_prog = { "fish", "-l" }

-- Performance
config.max_fps = 120
config.animation_fps = 60
config.front_end = "WebGpu"

return config
