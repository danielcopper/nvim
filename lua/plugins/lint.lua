-- nvim-lint: Linting support

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Configure linters by filetype
    -- Linters are automatically installed via mason-packages.lua
    lint.linters_by_ft = {
      -- javascript/typescript linting handled by ESLint LSP
      python = { "pylint" },
      -- lua = { "luacheck" }, -- Disabled: lua_ls LSP already provides diagnostics
      markdown = { "markdownlint" },
      yaml = { "yamllint" },
      json = { "jsonlint" },
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      dockerfile = { "hadolint" },
    }

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
