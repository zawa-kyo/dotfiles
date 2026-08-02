local M = {}

M.state = {
  hidden = true,
  ignored = false,
}

local function notify(label, value)
  vim.notify(("Snacks %s: %s"):format(label, value and "on" or "off"), vim.log.levels.INFO, {
    title = "Snacks",
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
  local value = not (current == nil and M.state[name] or current)

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

function M.opts()
  return {
    hidden = M.state.hidden,
    ignored = M.state.ignored,
  }
end

function M.sync_from_opts(opts)
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
