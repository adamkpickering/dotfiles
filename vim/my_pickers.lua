local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function list_directory_uv(path)
  local expanded_path = vim.fn.expand(path)
  local handle, err = vim.uv.fs_opendir(expanded_path)
  if not handle then
    print("Error opening directory: " .. err)
    return nil
  end

  local entries = {}
  while true do
    local entry = vim.uv.fs_readdir(handle)
    if entry == nil then
      break
    end
    if entry[1].name ~= "." and entry[1].name ~= ".." then
      table.insert(entries, entry[1].name)
    end
  end

  vim.uv.fs_closedir(handle)
  return entries
end

local M = {}

M.my_simple_picker = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "My Custom Items",
    finder = finders.new_table({
      results = list_directory_uv("~/dev"),
    }),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local path = vim.fs.joinpath(vim.fn.expand("~/dev"), selection[1])
        vim.cmd.cd(path)
      end)
      return true
    end,
  }):find()
end

return M
