vim.pack.add({
  "https://github.com/seblyng/roslyn.nvim",
  "https://github.com/khoido2003/roslyn-filewatch.nvim",
})

-- Worktree-aware solution chooser for roslyn.nvim
local function choose_target(targets)
  if #targets == 0 then
    return nil
  end
  if #targets == 1 then
    return targets[1]
  end

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

  local slnx = vim.iter(targets):filter(function(t) return t:match("%.slnx$") end):totable()
  local sln = vim.iter(targets):filter(function(t) return t:match("%.sln$") end):totable()
  local slnf = vim.iter(targets):filter(function(t) return t:match("%.slnf$") end):totable()

  if #slnx == 1 then return slnx[1]
  elseif #slnx > 1 then return nil end

  if #sln == 1 then return sln[1]
  elseif #sln > 1 then return nil end

  if #slnf == 1 then return slnf[1] end

  return nil
end

-- Configure LSP settings for roslyn
vim.lsp.config("roslyn", {
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
  end,
  handlers = {
    ["$/progress"] = function(err, result, ctx, config)
      if result and result.value and not result.token then
        result.token = "roslyn-progress"
      end
      vim.lsp.handlers["$/progress"](err, result, ctx, config)
    end,
  },
  on_attach = function(client, bufnr)
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

require("roslyn").setup({
  broad_search = true,
  lock_target = true,
  choose_target = choose_target,
  filewatching = "off",
})

require("roslyn_filewatch").setup({
  ignore_dirs = {
    ".worktrees",
    "node_modules",
    "obj", "Obj",
    "bin", "Bin",
    "Build", "Builds",
    "packages",
    "TestResults",
    ".git", ".idea", ".vs", ".vscode",
  },
})
