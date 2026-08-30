---@alias NeotestAction fun()
---@class NeotestActions
local M = {}

--- Run the nearest test under the cursor.
---@type NeotestAction
function M.run_nearest()
  require("neotest").run.run()
end

--- Run all tests in the current file.
---@type NeotestAction
function M.run_file()
  require("neotest").run.run(vim.fn.expand("%"))
end

--- Run all tests in the current working directory.
---@type NeotestAction
function M.run_workspace()
  require("neotest").run.run(vim.fn.getcwd())
end

--- Re-run the most recently executed test.
---@type NeotestAction
function M.run_last()
  require("neotest").run.run_last()
end

--- Stop the test nearest to the cursor.
---@type NeotestAction
function M.stop_nearest()
  require("neotest").run.stop()
end

--- Open test output and focus its window.
---@type NeotestAction
function M.show_output()
  require("neotest").output.open({ enter = true })
end

--- Toggle the test summary window.
---@type NeotestAction
function M.toggle_summary()
  require("neotest").summary.toggle()
end

return M
