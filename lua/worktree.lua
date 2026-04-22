-- worktree.lua — Git worktree switcher for nvim
--
-- No plugin dependencies. Uses telescope if available, falls back to vim.ui.select.
--
-- Switch orchestration (M.switch):
--   The order of operations is critical to avoid race conditions between LSP
--   clients and buffer path changes. Specifically:
--
--   1. Stop all LSP clients FIRST
--      - Buffers still have their old paths at this point, so LSP clients
--        send clean didClose notifications for the correct (old) URIs.
--      - If we remapped buffers first, the old LSP client would receive
--        didClose for the NEW paths it never opened → InvalidOperationException.
--      - Managed clients (those with a vim.lsp.config entry, e.g. roslyn, ts_ls)
--        are disabled via vim.lsp.enable(name, false) to prevent premature
--        restart from buffer/filetype events during the transition.
--      - Unmanaged clients (e.g. sonarlint.nvim, which uses its own startup
--        mechanism) are stopped directly. Sonarlint's internal root_dir→client_id
--        cache is also cleared so it doesn't try to reuse a dead client.
--      - Roslyn state: vim.g.roslyn_nvim_selected_solution is cleared so
--        lock_target doesn't reuse a stale solution path from the old worktree.
--
--   2. Change working directory (vim.fn.chdir)
--      - Fires DirChanged autocmd → neo-tree, gitsigns, lualine react.
--
--   3. Remap buffers
--      - For each loaded buffer under the old worktree path:
--        - If the file exists in the new worktree → rename buffer + reload
--        - If not → close buffer (prompt to save if modified)
--      - Safe to do now because no LSP clients are watching these buffers.
--
--   4. Reset neo-tree
--      - Worktrees live under .worktrees/ which is a subdir of the main repo.
--        Neo-tree's is_subpath() matches the new path to the already-cached
--        parent repo, so git status lookups fail. Clearing the internal worktree
--        cache forces re-discovery via git rev-parse from the new cwd.
--
--   5. Re-enable LSP clients after 500ms delay
--      - Managed clients: vim.lsp.enable(name) re-enables auto-attachment,
--        which starts fresh clients that discover the new worktree's project files.
--      - doautocmd FileType re-triggers filetype detection for the current buffer,
--        which causes unmanaged LSPs (sonarlint) to start fresh via their own
--        FileType autocmd handlers.
--
-- Keymaps (set in config/keymaps.lua):
--   <leader>gw → M.pick()    (interactive worktree picker)
--   <leader>gg → M.lazygit() (lazygit with auto-follow on worktree switch)

local M = {}

--- List all worktrees via `git worktree list --porcelain`.
--- Returns { { name, path, branch } }
local function list_worktrees()
  local lines = vim.fn.systemlist("git worktree list --porcelain")
  if vim.v.shell_error ~= 0 then return {} end

  local worktrees = {}
  local current = {}

  for _, line in ipairs(lines) do
    if line:match("^worktree ") then
      current = { path = line:match("^worktree (.+)") }
    elseif line:match("^branch ") then
      current.branch = line:match("^branch refs/heads/(.+)")
    elseif line == "" and current.path then
      current.name = current.branch or vim.fn.fnamemodify(current.path, ":t")
      table.insert(worktrees, current)
      current = {}
    end
  end
  -- Last entry (git doesn't always end with a blank line)
  if current.path then
    current.name = current.branch or vim.fn.fnamemodify(current.path, ":t")
    table.insert(worktrees, current)
  end

  return worktrees
end

--- Remap open buffers from old worktree path to new one.
--- If the same file exists in the new worktree, remap it.
--- Otherwise close the buffer (prompts to save if modified).
local function remap_buffers(old_path, new_path)
  old_path = old_path:gsub("/$", "")
  new_path = new_path:gsub("/$", "")
  if old_path == new_path then return end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
      local bufname = vim.api.nvim_buf_get_name(buf)
      if bufname:find(old_path, 1, true) == 1 then
        local relative = bufname:sub(#old_path + 1)
        local new_file = new_path .. relative
        if vim.fn.filereadable(new_file) == 1 then
          vim.api.nvim_buf_set_name(buf, new_file)
          vim.api.nvim_buf_call(buf, function()
            vim.cmd("silent edit!")
          end)
        else
          if vim.bo[buf].modified then
            vim.api.nvim_buf_call(buf, function()
              vim.cmd("confirm bdelete")
            end)
          else
            vim.api.nvim_buf_delete(buf, {})
          end
        end
      end
    end
  end
end

--- Stop all LSP clients and disable managed servers to prevent premature restart.
--- Returns a set of managed server names for later re-enabling.
local function stop_all_lsp()
  vim.g.roslyn_nvim_selected_solution = nil

  local managed_names = {}
  for _, client in ipairs(vim.lsp.get_clients()) do
    if vim.lsp.config[client.name] ~= nil then
      managed_names[client.name] = true
    end
    -- In-process LSP servers (like kulala) don't fully stop asynchronously.
    -- Force the exit callback so nvim removes them from the registry immediately,
    -- preventing duplicate clients when remap_buffers triggers FileType events.
    if type(client.config.cmd) == "function" then
      pcall(function() client.rpc.notify("exit") end)
    end
    client:stop(true)
  end

  -- Clear sonarlint's root_dir→client_id cache (it won't start fresh otherwise)
  pcall(function()
    require("sonarlint")._client_id_by_root_dir = {}
  end)

  -- Disable managed servers so buffer/filetype events don't restart them early
  for name in pairs(managed_names) do
    vim.lsp.enable(name, false)
  end

  return managed_names
end

--- Re-enable LSP clients after a delay to let old clients fully shut down.
local function restart_lsp(managed_names)
  vim.defer_fn(function()
    for name in pairs(managed_names) do
      vim.lsp.enable(name)
    end
  end, 500)

  -- Re-trigger FileType with a longer delay so unmanaged LSPs (sonarlint)
  -- re-attach AFTER managed clients have fully started (avoids duplicate roslyn).
  vim.defer_fn(function()
    vim.cmd("doautocmd FileType")
  end, 1500)
end

--- Switch to a worktree by path. See module header for detailed orchestration docs.
function M.switch(target_path)
  local old_path = vim.fn.getcwd()
  target_path = vim.fn.fnamemodify(target_path, ":p"):gsub("/$", "")

  if old_path == target_path then
    vim.notify("Already in this worktree", vim.log.levels.INFO)
    return
  end

  -- 1. Stop LSP clients (must happen before buffer remap)
  local managed_names = stop_all_lsp()

  -- 2. Change directory
  vim.fn.chdir(target_path)

  -- 3. Remap buffers (safe — no LSP clients are watching)
  remap_buffers(old_path, target_path)

  -- 4. Reset neo-tree (clear worktree cache, refresh at new root)
  if pcall(require, "neo-tree") then
    local prev_win = vim.api.nvim_get_current_win()
    pcall(function()
      local git = require("neo-tree.git")
      git.worktrees = {}
      if git._upward_worktree_cache then
        git._upward_worktree_cache = setmetatable({}, { __mode = "kv" })
      end
    end)
    local neotree_open = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "neo-tree" then
        neotree_open = true
        break
      end
    end
    if neotree_open then
      pcall(vim.cmd, "Neotree action=show dir=" .. target_path)
      if vim.api.nvim_win_is_valid(prev_win) and vim.bo[vim.api.nvim_win_get_buf(prev_win)].buftype == "" then
        vim.api.nvim_set_current_win(prev_win)
      end
      vim.defer_fn(function()
        pcall(function()
          local events = require("neo-tree.events")
          events.fire_event(events.GIT_EVENT)
        end)
      end, 200)
    end
  end

  -- 5. Re-enable LSP after delay
  restart_lsp(managed_names)

  -- Notify with branch name
  local branch = vim.fn.fnamemodify(target_path, ":t")
  for _, wt in ipairs(list_worktrees()) do
    if wt.path == target_path and wt.branch then
      branch = wt.branch
      break
    end
  end
  vim.notify("Switched WT: " .. branch, vim.log.levels.INFO)
end

--- Telescope picker for worktrees. Falls back to vim.ui.select.
function M.pick()
  local worktrees = list_worktrees()
  if #worktrees == 0 then
    vim.notify("No worktrees found", vim.log.levels.WARN)
    return
  end

  local cwd = vim.fn.getcwd()

  local has_telescope, telescope_pickers = pcall(require, "telescope.pickers")
  if has_telescope then
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local themes = require("telescope.themes")
    telescope_pickers.new(themes.get_dropdown({ previewer = false, width = 0.4 }), {
      prompt_title = "Worktrees",
      finder = finders.new_table({
        results = worktrees,
        entry_maker = function(wt)
          local marker = wt.path == cwd and " *" or ""
          return {
            value = wt,
            display = (wt.name or "?") .. marker,
            ordinal = wt.name or wt.path,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if entry then
            M.switch(entry.value.path)
          end
        end)
        return true
      end,
    }):find()
  else
    -- Fallback: vim.ui.select
    local items = {}
    for _, wt in ipairs(worktrees) do
      local marker = wt.path == cwd and " *" or ""
      table.insert(items, { label = wt.name .. marker, wt = wt })
    end
    vim.ui.select(items, {
      prompt = "Switch worktree:",
      format_item = function(item) return item.label end,
    }, function(choice)
      if choice then M.switch(choice.wt.path) end
    end)
  end
end

--- Open lazygit in a floating terminal.
--- If lazygit switches worktree, nvim follows on exit.
function M.lazygit()
  local newdir_file = vim.fn.tempname()
  local old_cwd = vim.fn.getcwd()

  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
  })

  vim.fn.termopen("lazygit", {
    cwd = old_cwd,
    env = { LAZYGIT_NEW_DIR_FILE = newdir_file },
    on_exit = function()
      pcall(vim.api.nvim_win_close, win, true)
      pcall(vim.api.nvim_buf_delete, buf, { force = true })

      vim.schedule(function()
        if vim.fn.filereadable(newdir_file) == 1 then
          local lines = vim.fn.readfile(newdir_file)
          local new_dir = lines[1]
          vim.fn.delete(newdir_file)
          if new_dir and new_dir ~= "" and new_dir ~= old_cwd then
            M.switch(new_dir)
          end
        end
      end)
    end,
  })

  vim.cmd("startinsert")
end

return M
