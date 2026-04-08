-- Worktree-aware solution chooser for roslyn.nvim
-- Extracted as a standalone function so it can be registered early (before LSP starts)
-- and also passed to roslyn.nvim setup().
local function choose_target(targets)
  if #targets == 0 then
    return nil
  end
  if #targets == 1 then
    return targets[1]
  end

  -- Scope targets to the current worktree/repo.
  -- broad_search + upward find discovers solutions from other worktrees too.
  -- In a worktree .git is a FILE → keep only targets under that worktree root.
  -- In the main repo .git is a DIRECTORY → exclude anything under .worktrees/.
  local root = vim.fs.root(0, ".git")
  if root then
    local git_path = root .. "/.git"
    local is_worktree = vim.fn.isdirectory(git_path) == 0 and vim.fn.filereadable(git_path) == 1
    local local_targets
    if is_worktree then
      local_targets = vim.iter(targets):filter(function(t)
        return t:find(root, 1, true) ~= nil
      end):totable()
    else
      local_targets = vim.iter(targets):filter(function(t)
        return t:find("/.worktrees/", 1, true) == nil
      end):totable()
    end
    if #local_targets > 0 then
      targets = local_targets
    end
  end
  if #targets == 1 then
    return targets[1]
  end

  -- Categorize by extension (priority: .slnx > .sln > .slnf)
  local slnx = vim.iter(targets):filter(function(t) return t:match("%.slnx$") end):totable()
  local sln = vim.iter(targets):filter(function(t) return t:match("%.sln$") end):totable()
  local slnf = vim.iter(targets):filter(function(t) return t:match("%.slnf$") end):totable()

  if #slnx == 1 then
    return slnx[1]
  elseif #slnx > 1 then
    return nil
  end

  if #sln == 1 then
    return sln[1]
  elseif #sln > 1 then
    return nil
  end

  if #slnf == 1 then
    return slnf[1]
  end

  return nil
end

-- Configure LSP settings for roslyn
vim.lsp.config("roslyn", {
  -- Prevent ghost clients: roslyn.nvim's root_dir can return nil when choose_target
  -- can't resolve a solution (e.g., during startup race). Neovim then starts a client
  -- with root_dir=nil. Override root_dir to swallow nil and prevent the ghost client.
  root_dir = function(bufnr, on_dir)
    local cfg = require("roslyn.config").get()
    if cfg.lock_target and vim.g.roslyn_nvim_selected_solution then
      on_dir(vim.fs.dirname(vim.g.roslyn_nvim_selected_solution))
      return
    end
    local root = require("roslyn.sln.utils").root_dir(bufnr)
    if root then
      on_dir(root)
    end
    -- nil root → don't call on_dir → no ghost client
  end,
  handlers = {
    -- Fix for noice.nvim: ensure progress messages have a token field
    ["$/progress"] = function(err, result, ctx, config)
      if result and result.value and not result.token then
        result.token = "roslyn-progress"
      end
      vim.lsp.handlers["$/progress"](err, result, ctx, config)
    end,
  },
  on_attach = function(client, bufnr)
    -- Roslyn-specific keybindings
    vim.keymap.set("n", "<leader>ct", "<cmd>Roslyn target<cr>", { buffer = bufnr, desc = "Select target framework" })
  end,
  settings = {
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
      csharp_enable_inlay_hints_for_lambda_parameter_types = true,
      csharp_enable_inlay_hints_for_types = true,
      dotnet_enable_inlay_hints_for_indexer_parameters = true,
      dotnet_enable_inlay_hints_for_literal_parameters = true,
      dotnet_enable_inlay_hints_for_object_creation_parameters = true,
      dotnet_enable_inlay_hints_for_other_parameters = true,
      dotnet_enable_inlay_hints_for_parameters = true,
      dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
  },
})

return {
  {
    "seblyng/roslyn.nvim",
    -- Must load early so choose_target is registered before roslyn's first
    -- is registered in time for the first root_dir() call.
    lazy = false,
    opts = {
      broad_search = true,
      lock_target = true,
      choose_target = choose_target,
      filewatching = "off",
    },
  },
  {
    "khoido2003/roslyn-filewatch.nvim",
    ft = "cs",
    opts = {
      ignore_dirs = {
        -- Worktrees contain duplicate node_modules trees (100k+ dirs)
        ".worktrees",
        -- Defaults from plugin
        "node_modules",
        "obj", "Obj",
        "bin", "Bin",
        "Build", "Builds",
        "packages",
        "TestResults",
        ".git", ".idea", ".vs", ".vscode",
      },
    },
  },
}
