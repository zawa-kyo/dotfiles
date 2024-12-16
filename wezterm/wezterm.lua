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

config.color_scheme = "nord"
config.window_background_opacity = 0.93


--[[
    Font
]]

local FONT_SIZE = 13.0
config.font = wezterm.font("Hack Nerd Font", {
    weight = "Regular",
    stretch = "Normal",
    italic = false
})
config.font_size = FONT_SIZE
config.window_frame = {
    font = wezterm.font("Hack Nerd Font", {
        weight = "Bold",
        italic = false,
    }),
    font_size = FONT_SIZE,
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

-- and finally, return the configuration to wezterm
return config
