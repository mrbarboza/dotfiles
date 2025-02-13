local wezterm = require("wezterm")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

local config = wezterm.config_builder()

config.color_scheme = "rose-pine"
config.colors = {
	tab_bar = {
		background = "#0b0022",
		active_tab = {
			bg_color = "#2b2042",
			fg_color = "#c0c0c0",
			intensity = "Normal",
			underline = "None",
			italic = false,
		},
		inactive_tab = {
			bg_color = "#1b1032",
			fg_color = "#808080",
		},
		inactive_tab_hover = {
			bg_color = "#3b3052",
			fg_color = "#909090",
		},
		new_tab = {
			bg_color = "#1b1032",
			fg_color = "#808080",
		},
		new_tab_hover = {
			bg_color = "#3b3052",
			fg_color = "#909090",
			italic = true,
		},
	},
}

config.font = wezterm.font("Iosevka Nerd Font")
config.font_rules = {
	{
		italic = true,
		font = wezterm.font("Iosevka Nerd Font", { style = "Italic" }),
	},
	{
		intensity = "Bold",
		font = wezterm.font("Iosevka Nerd Font", { weight = "Bold" }),
	},
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font("Iosevka Nerd Font", { weight = "Bold", style = "Italic" }),
	},
}
config.font_size = 17.0

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.88

config.hide_tab_bar_if_only_one_tab = true

config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "|",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "m",
		mods = "LEADER",
		action = wezterm.action.TogglePaneZoomState,
	},
	-- Giving a TMUX keybinding for Wezterm
	{
		key = ",",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = "c",
		mods = "LEADER",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "&",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "w",
		mods = "LEADER",
		action = wezterm.action.ShowTabNavigator,
	},
	{
		key = "n",
		mods = "LEADER",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = "p",
		mods = "LEADER",
		action = wezterm.action.ActivateTabRelative(-1),
	},
}

config.term = "xterm-256color"

smart_splits.apply_to_config(config, {
	directions = { "j", "k", "h", "l" },
	modifiers = {
		move = "CTRL",
		resize = "META",
	},
	log_level = "info",
})

return config
