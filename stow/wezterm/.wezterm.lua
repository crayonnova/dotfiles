-- WezTerm is configured using Lua
local wezterm = require("wezterm")

-- Use the config builder when available (newer WezTerm versions)
-- This gives better error messages and future compatibility
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end
-- My configs

-- GENERAL BEHAVIOR
-- =========================================================

-- Disable auto-update checks
-- Reason: deterministic startup, no surprise network calls
-- Other values: true
config.check_for_updates = false

-- Enable tab bar (useful when not using tmux) Other values: false
config.enable_tab_bar = false

-- Fancy tab bar adds GPU + layout overhead
-- Disable when you primarily live in Neovim splits
-- Other values: true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- Position of the tab bar
-- Other values: "Bottom"
config.tab_bar_at_bottom = false

-- Avoid close confirmation dialogs
-- Other values: "AlwaysPrompt"
config.window_close_confirmation = "AlwaysPrompt"

-- =========================================================
-- FONT (CRITICAL FOR NEOVIM)
-- =========================================================

-- font_with_fallback ensures glyphs always exist
-- Nerd Font is REQUIRED for LazyVim icons
config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	"JetBrainsMono Nerd Font Mono",
	"Cascadia Code", -- fallback until HM switch installs JetBrains live
	"Noto Color Emoji",
})
-- Font size in points
-- Typical range: 11.0 - 14.0
config.font_size = 13.2

-- Line height multiplier
-- 1.0 = tight, 1.2 = airy
config.line_height = 1.1

-- =========================================================
-- RENDERING (WINDOWS 11 OPTIMAL)
-- =========================================================

-- Best rendering backend on Windows 11
-- Other values:
--   "OpenGL"   (older, more compatible)
--   "Software" (slow, fallback only)
config.front_end = "WebGpu"

-- FPS limits (avoid unnecessary GPU usage)
config.max_fps = 144
config.animation_fps = 60

-- GPU power preference
-- Other values: "LowPower"
config.webgpu_power_preference = "HighPerformance"

-- =========================================================
-- COLORS / TRANSPARENCY
-- =========================================================

-- Built-in color scheme
-- List available schemes with: wezterm ls-colors
config.color_scheme = "Tokyo Night"
-- Window background opacity

-- 1.0 = fully opaque
-- Below ~0.90 may cause text blur on Windows
config.window_background_opacity = 0.8

-- Text background opacity
-- Keep at 1.0 for crisp Neovim rendering
config.text_background_opacity = 1.0

-- =========================================================
-- CURSOR (MATCH VIM FEEL)
-- =========================================================

-- Cursor shape
-- Other values:
--   "SteadyBlock"
--   "BlinkingBlock"
--   "BlinkingUnderline"
config.default_cursor_style = "BlinkingBar"

-- Blink rate in ms
-- 0 disables blinking
config.cursor_blink_rate = 600

-- =========================================================
-- WINDOW BEHAVIOR
-- =========================================================

-- Window decorations
-- "RESIZE" removes title bar but allows resizing
-- Other values:
--   "TITLE | RESIZE"
--   "NONE"
config.window_decorations = "NONE"

-- Prevent window resize when changing font size
-- Important for stable Neovim layouts
config.adjust_window_size_when_changing_font_size = false

-- =========================================================
-- SCROLLBACK
-- =========================================================

-- Number of lines kept in scrollback
-- Neovim users typically do not need huge values
config.scrollback_lines = 5000

-- =========================================================
-- DEFAULT SHELL (WINDOWS)
-- =========================================================

-- PowerShell 7 is recommended over:
--   - cmd.ex
--   - Windows PowerShell 5.1
-- config.default_prog = {
-- 	"C:/Program Files/PowerShell/7/pwsh.exe",
-- 	"-NoLogo",
-- }

-- =========================================================
-- KEYBINDINGS (NEOVIM-ALIGNED)
-- =========================================================

-- Keep default bindings enabled
-- Set to true only if you want full control
config.disable_default_key_bindings = false

-- ALT-based bindings avoid conflict with Vim leader keys
config.keys = {
	-- Pane splitting (similar to tmux, not Vim)
	{ key = "d", mods = "ALT", action = wezterm.action.SplitHorizontal },
	{ key = "D", mods = "ALT|SHIFT", action = wezterm.action.SplitVertical },

	-- Pane navigation (hjkl muscle memory)
	{ key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },

	-- Close current pane without confirmation
	{ key = "w", mods = "ALT", action = wezterm.action.CloseCurrentPane({ confirm = false }) },

	-- Font scaling (terminal-only, not Neovim)
	{ key = "+", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
	{ key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },
	{ key = "Backspace", mods = "CTRL", action = wezterm.action.SendKey({ key = "w", mods = "CTRL" }) },

	-- SEARCH FUNCTIONALITY
	-- Enter search mode (case-insensitive)
	{ key = "F", mods = "CTRL|SHIFT", action = wezterm.action.Search({ CaseInSensitiveString = "" }) },

	-- Quick Select (instant pattern matching)
	{ key = "Space", mods = "CTRL|SHIFT", action = wezterm.action.QuickSelect },

	-- Copy Mode (Vim-style)
	{ key = "C", mods = "CTRL|SHIFT", action = wezterm.action.ActivateCopyMode },

	-- Predefined regex searches
	-- { key = "H", mods = "CTRL|SHIFT", action = wezterm.action.Search { Regex = "[a-f0-9]{6,}" } }, -- Git hashes
	-- { key = "U", mods = "CTRL|SHIFT", action = wezterm.action.Search { Regex = "https?://[^\\s]+" } }, -- URLs
	-- { key = "P", mods = "CTRL|SHIFT", action = wezterm.action.Search { Regex = "[a-zA-Z]:\\\\[^\\s\"]+" } }, -- Paths
}

-- =========================================================
-- MISC
-- =========================================================

-- Disable bell sounds
-- Other values: "SystemBeep"
config.audible_bell = "Disabled"

-- When the shell exits, close the window
-- Other values: "Hold"
config.exit_behavior = "Close"

harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

config.inactive_pane_hsb = {
	saturation = 0.5,
	brightness = 0.5,
}

-- =========================================================
-- STATUS BAR (SHOW SESSION/PROCESS)
-- =========================================================
wezterm.on("update-right-status", function(window, pane)
	local workspace = window:active_workspace()
	local process_info = pane:get_foreground_process_info()
	local process_name = process_info and process_info.name or "unknown"

	window:set_right_status(wezterm.format({
		{ Foreground = { Color = "#7aa2f7" } }, -- Tokyo Night Blue
		{ Text = "   " .. workspace .. "  " },
		{ Foreground = { Color = "#bb9af7" } }, -- Tokyo Night Purple
		{ Text = "   " .. process_name .. " " },
	}))
end)

config.default_gui_startup_args = { "connect", "local" }

config.window_padding = {
	left = 10,
	right = 10,
	top = 0,
	bottom = 23
}

-- Quick Select Patterns (instant pattern matching)
config.quick_select_patterns = {
	-- URLs
	"https?://[^\\s]+",
	-- Windows file paths
	'[a-zA-Z]:\\\\[^\\s"]+',
	-- Git commits (7-40 hex characters)
	"[0-9a-f]{7,40}",
	-- Email addresses
	"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}",
	-- IP addresses
	"\\b(?:\\d{1,3}\\.){3}\\d{1,3}\\b",
}
-- =========================================================
-- TAB BAR WITH STATUS ICONS
-- =========================================================
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local process_info = tab.active_pane:get_foreground_process_info()
	local process_name = process_info and process_info.name or "unknown"

	local icon = ""
	if process_name:find("pwsh") or process_name:find("powershell") then
		icon = "⚡"
	elseif process_name:find("bash") or process_name:find("wsl") or process_name:find("ubuntu") then
		icon = "🐧"
	elseif process_name:find("cmd") then
		icon = "⌘"
	elseif process_name:find("nvim") or process_name:find("vim") then
		icon = ""
	elseif process_name:find("lazygit") then
		icon = ""
	end

	local fg_color = "#7aa2f7"
	local bg_color = "#1f2335"

	if tab.is_active then
		fg_color = "#bb9af7"
		bg_color = "#292e42"
	elseif hover then
		bg_color = "#24283b"
	end

	return {
		{ Background = { Color = bg_color } },
		{ Foreground = { Color = fg_color } },
		{ Text = " " .. icon .. " " },
		{ Foreground = { Color = "#73daca" } },
		{ Text = process_name .. " " },
	}
end)

-- Tab bar styling to match Tokyo Night theme
config.colors = {
	tab_bar = {
		background = "#1f2335",
		active_tab = {
			bg_color = "#292e42",
			fg_color = "#bb9af7",
			intensity = "Normal",
		},
		inactive_tab = {
			bg_color = "#1f2335",
			fg_color = "#7aa2f7",
		},
		inactive_tab_hover = {
			bg_color = "#24283b",
			fg_color = "#7aa2f7",
		},
		new_tab = {
			bg_color = "#1f2335",
			fg_color = "#7aa2f7",
		},
		new_tab_hover = {
			bg_color = "#24283b",
			fg_color = "#7aa2f7",
		},
	},
}
return config
