local M = {}
local file_exclusions = require("plugins.files.exclusions")

local state = {
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

-- Return open explorer pickers on the current tab.
local function active_explorers()
  return require("snacks").picker.get({ source = "explorer" })
end

-- Toggle a visibility option and refresh any open explorer pickers.
local function toggle(name)
  local explorers = active_explorers()
  local current = explorers[1] and explorers[1].opts[name]
  local value
  if current == nil then
    value = not state[name]
  else
    value = not current
  end

  state[name] = value
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
    hidden = state.hidden,
    ignored = state.ignored,
    exclude = file_exclusions.names,
  }
end

-- Return stable workspace-search options without navigation toggle state.
function M.search_opts()
  return {
    hidden = true,
    ignored = false,
    exclude = file_exclusions.names,
  }
end

-- Synchronize shared navigation state from a file picker.
function M.sync_navigation(opts)
  if not opts then
    return
  end
  if opts.hidden ~= nil then
    state.hidden = opts.hidden
  end
  if opts.ignored ~= nil then
    state.ignored = opts.ignored
  end
end

return M
