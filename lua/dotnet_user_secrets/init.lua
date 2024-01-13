local actions = require('telescope.actions')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values

local M = {}

local function get_user_secrets_directory()
  local os_name = vim.loop.os_uname().sysname
  if os_name == "Windows_NT" then
    return os.getenv("APPDATA") .. "\\Microsoft\\UserSecrets"
  else
    -- TODO: needs to be tested for linux path.
    return os.getenv("HOME") .. "/.microsoft/usersecrets"
  end
end

local function find_csproj_files()
  local csproj_files = {}
  -- Logic to find and add .csproj files in CWD to csproj_files
  return csproj_files
end

local function extract_guids_from_csproj(csproj_files)
  local guids = {}
  -- Logic to extract GUIDs from each .csproj file and add to guids
  return guids
end

function M.list_user_secrets()
  local search_directory = get_user_secrets_directory()
  local command = {}
  local os_name = vim.loop.os_uname().sysname

  if os_name == "Windows_NT" then
    -- Windows: Use 'dir' to list all files recursively, and 'findstr' to filter for 'secrets.json'
    command = { 'cmd', '/c', 'dir', search_directory .. '\\secrets.json', '/b', '/s' }
  else
    -- Linux/macOS: Find 'secrets.json' files
    command = { 'find', search_directory, '-name', 'secrets.json' }
  end

  -- TODO: add logic to find the secrets json for the current csproj or all proj files in the cwd.
  -- maybe its possible to use the dotnet cli for that.
  -- 'dotnet user-secrets list' should list all secrets for the current proj.
  --
  -- a problem is, that after dotnet user-secrets init the secrets.json is not yet created.
  -- only after adding the first secret will the file be created. so maybe extend this to parse the guid from
  -- csproj and then open a buffer which will then be saved to the correct location.
  --
  -- a good workflow would be:
  -- 1. executing the keymap does check if a guid exists. if not it will execute the init command and then open the file.
  -- 2. when there is no file yet but a guid we create the file.

  local entry_maker = function(entry)
    return {
      value = entry,
      display = entry,
      ordinal = entry,
      path = entry, -- Store the file path for later actions
    }
  end

  pickers.new({}, {
    prompt_title = "User Secrets",
    finder = finders.new_oneshot_job(command, { cwd = search_directory }),
    sorter = conf.file_sorter({}),
    previewer = conf.file_previewer({}), -- Add file previewer
    attach_mappings = function(_, map)
      actions.select_default:replace(function(prompt_bufnr)
        local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        if content then
          vim.cmd('edit ' .. content.value) -- Open the file in Neovim
        end
      end)
      return true
    end,
    entry_maker = entry_maker
  }):find()
end

return M
