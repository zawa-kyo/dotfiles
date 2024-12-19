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
config.color_scheme = "Cobalt 2 (Gogh)"
-- Opacity and blur
config.window_background_opacity = 0.90
config.macos_window_background_blur = 15
-- Hide title bar
config.window_decorations = "RESIZE"
-- Only display tabs when there are two or more
config.hide_tab_bar_if_only_one_tab = false
-- Render the tab bar in a native style
config.use_fancy_tab_bar = false
-- Customize tab bar
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local background = "#122534"
    local foreground = "#FFFFFF"

    if tab.is_active then
        background = "#ae8b2d"
        foreground = "#FFFFFF"
    end
    local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

    return {
        { Background = { Color = background } },
        { Foreground = { Color = foreground } },
        { Text = title },
    }
end)


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
}


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
