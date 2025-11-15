return {
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    dependencies = {
      "williamboman/mason.nvim",
    },
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
      local mason_registry = require("mason-registry")

      local function ensure_roslyn_installed()
        if not mason_registry.is_installed("roslyn") then
          vim.notify("Installing roslyn...", vim.log.levels.INFO)
          local ok, roslyn = pcall(mason_registry.get_package, "roslyn")
          if ok then
            roslyn:install():once("closed", function()
              if roslyn:is_installed() then
                vim.notify("roslyn installed successfully", vim.log.levels.INFO)
              else
                vim.notify("Failed to install roslyn", vim.log.levels.ERROR)
              end
            end)
          else
            vim.notify("roslyn package not found in Mason registry", vim.log.levels.WARN)
          end
        end
      end

      if mason_registry.refresh then
        mason_registry.refresh(ensure_roslyn_installed)
      else
        ensure_roslyn_installed()
      end

      require("roslyn").setup(opts)
    end,
  },
  {
    "khoido2003/roslyn-filewatch.nvim",
    ft = "cs",
    opts = {},
  }
}
