local M = {}

local snippets = require("plugins.picker.snippets")

local function picker()
  return require("snacks").picker
end

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

M.keys = {
  {
    "sb",
    function()
      picker().buffers()
    end,
    desc = "Search buffers",
  },
  {
    "sB",
    function()
      picker().grep({ buffers = true })
    end,
    desc = "Search words in current buffers",
  },
  {
    "sc",
    function()
      picker().pick({
        items = colorscheme_items(),
        format = "text",
        preview = "colorscheme",
        preset = "vertical",
        confirm = function(picker, item)
          picker:close()
          if item then
            picker.preview.state.colorscheme = nil
            vim.schedule(function()
              vim.cmd("colorscheme " .. item.text)
            end)
          end
        end,
      })
    end,
    desc = "Search colorschemes",
  },
  {
    "sd",
    function()
      picker().diagnostics_buffer()
    end,
    desc = "Search diagnostics in current buffer",
  },
  {
    "sD",
    function()
      picker().diagnostics()
    end,
    desc = "Search diagnostics in workspace",
  },
  {
    "sf",
    function()
      picker().files()
    end,
    desc = "Search files in workspace",
  },
  {
    "sF",
    function()
      picker().recent()
    end,
    desc = "Search recent files",
  },
  {
    "sgb",
    function()
      picker().git_branches()
    end,
    desc = "Search git branches",
  },
  {
    "sgd",
    function()
      picker().git_diff()
    end,
    desc = "Search git diffs (hunks)",
  },
  {
    "sgf",
    function()
      picker().git_log_file()
    end,
    desc = "Search git log file",
  },
  {
    "sgF",
    function()
      picker().git_files()
    end,
    desc = "Search git files",
  },
  {
    "sgl",
    function()
      picker().git_log()
    end,
    desc = "Search git logs",
  },
  {
    "sgL",
    function()
      picker().git_log_line()
    end,
    desc = "Search git log lines",
  },
  {
    "sgs",
    function()
      picker().git_status()
    end,
    desc = "Search git status",
  },
  {
    "sgS",
    function()
      picker().git_stash()
    end,
    desc = "Search git stash",
  },
  {
    "sh",
    function()
      picker().help()
    end,
    desc = "Search helps",
  },
  {
    "si",
    function()
      picker().icons()
    end,
    desc = "Search icons",
  },
  {
    "sk",
    function()
      picker().keymaps()
    end,
    desc = "Search keymaps",
  },
  {
    "sl",
    function()
      picker().loclist()
    end,
    desc = "Search loclist",
  },
  {
    "sL",
    function()
      picker().lazy()
    end,
    desc = "Search for plugin spec",
  },
  {
    "sm",
    function()
      picker().smart()
    end,
    desc = "Smart search for files and words",
  },
  {
    "sM",
    function()
      picker().marks()
    end,
    desc = "Search marks",
  },
  {
    "sn",
    function()
      picker().notifications()
    end,
    desc = "Search notifications",
  },
  {
    "sN", -- search snippets
    function()
      snippets.search_snippets()
    end,
    desc = "Search snippets",
  },
  {
    "sp",
    function()
      picker().pickers()
    end,
    desc = "Search pickers",
  },
  {
    "sP",
    function()
      picker().projects()
    end,
    desc = "Search projects",
  },
  {
    "sq",
    function()
      picker().qflist()
    end,
    desc = "Search quickfix list",
  },
  {
    "sr",
    function()
      picker().registers()
    end,
    desc = "Search registers",
  },
  {
    "sR",
    function()
      picker().resume()
    end,
    desc = "Resume previous picker",
  },
  {
    "ss",
    function()
      picker().lsp_symbols()
    end,
    desc = "Search LSP symbols in current buffer",
  },
  {
    "sS",
    function()
      picker().lsp_workspace_symbols()
    end,
    desc = "Search LSP symbols in workspace",
  },
  {
    "st",
    function()
      picker().treesitter()
    end,
    desc = "Search Tree-sitter symbols in current buffer",
  },
  {
    "sT",
    function()
      picker().todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
    end,
    desc = "Search todo comments (Todo/Fix/Fixme)",
  },
  {
    "su",
    function()
      picker().undo()
    end,
    desc = "Search undos",
  },
  {
    "sw",
    function()
      picker().lines()
    end,
    desc = "Search lines in current buffer",
  },
  {
    "sW",
    function()
      picker().grep()
    end,
    desc = "Search words in workspace",
  },
  {
    "sz",
    function()
      picker().zoxide()
    end,
    desc = "Search directories via zoxide",
  },
}

M.vscode = function()
  local utils = require("config.utils")

  utils.vscode_map("sf", "workbench.action.quickOpen", "Search files in workspace (VSCode)")
  utils.vscode_map("sW", "workbench.action.findInFiles", "Search words in workspace (VSCode)")
  utils.vscode_map("sw", "actions.find", "Search words in file (VSCode)")
end

return M
