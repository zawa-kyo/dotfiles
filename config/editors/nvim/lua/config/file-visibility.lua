local M = {}
local file_ignore = require("config.ignore")

M.state = {
  hidden = true,
  ignored = false,
}

local labels = {
  hidden = "Dotfiles",
  ignored = "Git-ignored files",
}

local function notify(name, visible)
  vim.notify(("%s: %s"):format(labels[name], visible and "shown" or "hidden"), vim.log.levels.INFO, {
    title = "File visibility",
  })
end

-- Return open explorer pickers without requiring Snacks during startup.
local function active_explorers()
  local ok, snacks = pcall(require, "snacks")
  if not ok or not snacks.picker then
    return {}
  end

  return snacks.picker.get({ source = "explorer" }) or {}
end

-- Toggle a visibility option and refresh any open explorer pickers.
local function toggle(name)
  local explorers = active_explorers()
  local current = explorers[1] and explorers[1].opts[name]
  local value
  if current == nil then
    value = not M.state[name]
  else
    value = not current
  end

  M.state[name] = value
  for _, picker in ipairs(explorers) do
    if not picker.closed and picker.opts[name] ~= value then
      picker:action("toggle_" .. name)
    end
  end

  notify(name, value)
end

function M.toggle_hidden()
  toggle("hidden")
end

function M.toggle_ignored()
  toggle("ignored")
end

-- Return shared visibility options for file navigation.
function M.navigation_opts()
  return {
    hidden = M.state.hidden,
    ignored = M.state.ignored,
    exclude = file_ignore.exact_names,
  }
end

-- Return stable workspace-search options without navigation toggle state.
function M.search_opts()
  return {
    hidden = true,
    ignored = false,
    exclude = file_ignore.exact_names,
  }
end

-- Synchronize shared navigation state from a file picker.
function M.sync_navigation(opts)
  if not opts then
    return
  end
  if opts.hidden ~= nil then
    M.state.hidden = opts.hidden
  end
  if opts.ignored ~= nil then
    M.state.ignored = opts.ignored
  end
end

return M
