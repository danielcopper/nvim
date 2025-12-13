-- Configure LSP settings for roslyn
vim.lsp.config("roslyn", {
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
    ft = "cs",
    opts = {
      broad_search = true,
      lock_target = true,
      -- Priority: .slnx > .sln > .slnf
      -- Auto-select if only one of highest priority type, otherwise prompt
      choose_target = function(targets)
        if #targets == 0 then
          return nil
        end
        if #targets == 1 then
          return targets[1]
        end

        -- Categorize by extension
        local slnx = vim.iter(targets):filter(function(t) return t:match("%.slnx$") end):totable()
        local sln = vim.iter(targets):filter(function(t) return t:match("%.sln$") end):totable()
        local slnf = vim.iter(targets):filter(function(t) return t:match("%.slnf$") end):totable()

        -- Priority 1: .slnx
        if #slnx == 1 then
          return slnx[1]
        elseif #slnx > 1 then
          return nil -- prompt user
        end

        -- Priority 2: .sln
        if #sln == 1 then
          return sln[1]
        elseif #sln > 1 then
          return nil -- prompt user
        end

        -- Priority 3: .slnf
        if #slnf == 1 then
          return slnf[1]
        end

        -- Multiple or unknown - prompt user
        return nil
      end,
    },
  },
  {
    "khoido2003/roslyn-filewatch.nvim",
    ft = "cs",
    opts = {},
  }
}
