local M = {}

local colorscheme_allowlist = {
  nord = true,
  nordfox = true,
  nordic = true,
}

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
    if (ext == "vim" or ext == "lua") and colorscheme_allowlist[name] then
      items[#items + 1] = {
        text = name,
        file = file,
      }
    end
  end
  return items
end

local function confirm_colorscheme(picker, item)
  picker:close()
  if item then
    picker.preview.state.colorscheme = nil
    vim.schedule(function()
      vim.cmd("colorscheme " .. item.text)
    end)
  end
end

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
