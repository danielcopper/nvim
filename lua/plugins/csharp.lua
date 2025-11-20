return {
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    opts = {
      config = {
        root_dir = function(fname)
          local util = require("lspconfig.util")
          -- Prefer .slnx (new format) over .sln (old format)
          return util.root_pattern("*.slnx", "*.sln", "*.csproj", ".git")(fname)
            or util.find_git_ancestor(fname)
        end,
        handlers = {
          -- Fix for noice.nvim: ensure progress messages have a token field
          ["$/progress"] = function(err, result, ctx, config)
            -- Ensure token exists (noice.nvim requires it)
            if result and result.value and not result.token then
              result.token = "roslyn-progress"
            end
            -- Call the default handler
            vim.lsp.handlers["$/progress"](err, result, ctx, config)
          end,
        },
        on_attach = function(client, bufnr)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          -- Roslyn-specific commands
          map("n", "<leader>ct", "<cmd>Roslyn target<cr>", "Select target framework")
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
      },
      broad_search = true,
    },

    config = function(_, opts)
      require("roslyn").setup(opts)
    end,
  },
  {
    "khoido2003/roslyn-filewatch.nvim",
    ft = "cs",
    opts = {},
  }
}
