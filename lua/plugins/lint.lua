-- nvim-lint: Linting support

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function()
    local lint = require("lint")

    -- Configure linters by filetype
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      python = { "pylint" },
      -- lua = { "luacheck" }, -- Disabled: lua_ls LSP already provides diagnostics
      markdown = { "markdownlint" },
      yaml = { "yamllint" },
      json = { "jsonlint" },
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      dockerfile = { "hadolint" },
    }

    -- Auto-install linters via Mason
    local linters_to_install = {
      "eslint_d",
      "pylint",
      -- "luacheck", -- Disabled: lua_ls LSP already provides diagnostics
      "markdownlint",
      "shellcheck",
      "hadolint",
    }

    local function ensure_linters_installed()
      local registry = require("mason-registry")

      for _, linter in ipairs(linters_to_install) do
        if not registry.is_installed(linter) then
          vim.notify("Installing " .. linter .. "...", vim.log.levels.INFO)
          local ok, package = pcall(registry.get_package, linter)
          if ok then
            package:install():once("closed", function()
              if package:is_installed() then
                vim.notify(linter .. " installed successfully", vim.log.levels.INFO)
              else
                vim.notify("Failed to install " .. linter, vim.log.levels.ERROR)
              end
            end)
          else
            vim.notify("Package " .. linter .. " not found in Mason registry", vim.log.levels.WARN)
          end
        end
      end
    end

    -- Wait for Mason registry to load
    local mason_registry = require("mason-registry")
    if mason_registry.refresh then
      mason_registry.refresh(ensure_linters_installed)
    else
      ensure_linters_installed()
    end

    -- Auto-lint on save and text changes
    local lint_augroup = vim.api.nvim_create_augroup("nvim_lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged" }, {
      group = lint_augroup,
      callback = function()
        -- Only lint if the buffer has a linter configured
        local ft = vim.bo.filetype
        if lint.linters_by_ft[ft] then
          lint.try_lint()
        end
      end,
    })

    -- Manual lint command
    vim.api.nvim_create_user_command("Lint", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
