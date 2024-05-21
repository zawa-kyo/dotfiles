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

-- colors
config.color_scheme = 'Mariana'
config.window_background_opacity = 0.93

-- font
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

-- and finally, return the configuration to wezterm
return config
