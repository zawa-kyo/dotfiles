local M = {}

---Theme names allowed in the colorscheme picker.
local colorscheme_allowlist = {
  "nord",
  "nordfox",
  "nordic",
}

---Build a lookup table for allowlist membership checks.
local function build_allowlist_set()
  local set = {}
  for _, name in ipairs(colorscheme_allowlist) do
    set[name] = true
  end
  return set
end

local colorscheme_allowlist_set = build_allowlist_set()

---Collect colorscheme items limited to the allowlist.
local function colorscheme_items()
  local items = {}
  local rtp = vim.o.runtimepath
  if package.loaded.lazy then
    rtp = rtp .. "," .. table.concat(require("lazy.core.util").get_unloaded_rtp(""), ",")
  end
  local files = vim.fn.globpath(rtp, "colors/*", false, true)
  for _, file in ipairs(files) do
    local name = vim.fn.fnamemodify(file, ":t:r")
    local ext = vim.fn.fnamemodify(file, ":e")
    if (ext == "vim" or ext == "lua") and colorscheme_allowlist_set[name] then
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
