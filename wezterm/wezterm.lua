-- Pull in the wezterm API
local wezterm = require 'wezterm'
local config = {}

-- show basename
local function BaseName(s)
    return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

wezterm.on('format-window-title', function(tab)
    return BaseName(tab.active_pane.foreground_process_name)
end)

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end


--[[
    Colors
]]

-- Theme
config.color_scheme = "nord"
-- Opacity and blur
config.window_background_opacity = 0.90
config.macos_window_background_blur = 15


--[[
    Fonts
]]

local FONT_SIZE = 13.0
config.font = wezterm.font("Hack Nerd Font", {
    weight = "Regular",
    stretch = "Normal",
    italic = false
})
config.font_size = FONT_SIZE
-- Make the tab bar transparent
config.window_frame = {
    font = wezterm.font("Hack Nerd Font", {
        weight = "Bold",
        italic = false,
    }),
    font_size = FONT_SIZE,
    inactive_titlebar_bg = "none",
    active_titlebar_bg = "none",
}
config.window_decorations = 'RESIZE'


--[[
    Keybindings
]]

-- デフォルトの keybindings を無効化
config.disable_default_key_bindings = true
-- `keybindings.lua`を読み込み
local keybindings = require 'keybindings'
-- keybindingsの設定
config.keys = keybindings.keys
config.key_tables = keybindings.key_tables
-- Leaderキーの設定
config.leader = { key = ",", mods = "CTRL", timeout_milliseconds = 2000 }


--[[
    Options
]]

-- 日本語IMEを有効化
config.use_ime = true


--[[
    Return configuration
]]

-- and finally, return the configuration to wezterm
return config
