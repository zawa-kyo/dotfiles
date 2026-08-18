local M = {}

local NIGHTFOX_THEMES = {
  "nightfox",
  "dayfox",
  "dawnfox",
  "duskfox",
  "nordfox",
  "terafox",
  "carbonfox",
}

local EVERGARDEN_THEMES = {
  "evergarden",
}

local TOKYONIGHT_THEMES = {
  "tokyonight",
  "tokyonight-night",
  "tokyonight-storm",
  "tokyonight-day",
  "tokyonight-moon",
}

local CATPPUCCIN_THEMES = {
  "catppuccin",
  "catppuccin-latte",
  "catppuccin-frappe",
  "catppuccin-macchiato",
  "catppuccin-mocha",
}

local ONEDARK_THEMES = {
  "onedark",
}

---Collect colorscheme names from theme spec filenames.
local function theme_allowlist_set()
  local set = {}
  local theme_dir = vim.fn.stdpath("config") .. "/lua/plugins/theme"
  local files = vim.fn.globpath(theme_dir, "*.lua", false, true)
  for _, file in ipairs(files) do
    local name = vim.fn.fnamemodify(file, ":t:r")
    if name ~= "init" then
      set[name] = true
    end
  end

  for _, name in ipairs(NIGHTFOX_THEMES) do
    set[name] = true
  end

  for _, name in ipairs(EVERGARDEN_THEMES) do
    set[name] = true
  end

  for _, name in ipairs(TOKYONIGHT_THEMES) do
    set[name] = true
  end

  for _, name in ipairs(CATPPUCCIN_THEMES) do
    set[name] = true
  end

  for _, name in ipairs(ONEDARK_THEMES) do
    set[name] = true
  end

  return set
end

---Collect colorscheme items limited to the allowlist.
local function colorscheme_items()
  local items = {}
  local allowlist = theme_allowlist_set()
  local rtp = vim.o.runtimepath
  if package.loaded.lazy then
    rtp = rtp .. "," .. table.concat(require("lazy.core.util").get_unloaded_rtp(""), ",")
  end
  local files = vim.fn.globpath(rtp, "colors/*", false, true)
  for _, file in ipairs(files) do
    local name = vim.fn.fnamemodify(file, ":t:r")
    local ext = vim.fn.fnamemodify(file, ":e")
    if (ext == "vim" or ext == "lua") and allowlist[name] then
      items[#items + 1] = {
        text = name,
        file = file,
      }
    end
  end
  return items
end

---Apply the selected colorscheme and close the picker.
local function confirm_colorscheme(picker, item)
  picker:close()
  if item then
    picker.preview.state.colorscheme = nil
    vim.schedule(function()
      vim.cmd("colorscheme " .. item.text)
    end)
  end
end

---Open the colorscheme picker with the allowlist filter.
function M.open(picker_fn)
  picker_fn().pick({
    items = colorscheme_items(),
    format = "text",
    preview = "colorscheme",
    preset = "vertical",
    confirm = confirm_colorscheme,
  })
end

return M
