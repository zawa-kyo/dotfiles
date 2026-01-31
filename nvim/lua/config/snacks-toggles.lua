local M = {}

M.state = {
  hidden = false,
  ignored = false,
}

local function notify(label, value)
  vim.notify(("Snacks %s: %s"):format(label, value and "on" or "off"), vim.log.levels.INFO, {
    title = "Snacks",
  })
end

function M.toggle_hidden()
  M.state.hidden = not M.state.hidden
  notify("hidden", M.state.hidden)
end

function M.toggle_ignored()
  M.state.ignored = not M.state.ignored
  notify("ignored", M.state.ignored)
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
