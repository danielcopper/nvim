return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
  },
  keys = {
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>",     mode = { "n", "v" }, desc = "AI Actions" },
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI Chat Toggle" },
    {
      "<leader>at",
      function()
        -- Toggle extended thinking mode
        local config = require("codecompanion").config
        local adapter = config.adapters.http.anthropic
        local current = adapter.schema.extended_thinking or false
        adapter.schema.extended_thinking = not current
        vim.notify(
          "Extended thinking: " .. (adapter.schema.extended_thinking and "ON" or "OFF"),
          vim.log.levels.INFO
        )
      end,
      desc = "Toggle AI Thinking Mode"
    },
    {
      "<leader>ap",
      function()
        -- Toggle between chat and agentic mode by changing adapter
        local ok, CodeCompanion = pcall(require, "codecompanion")
        if not ok then
          vim.notify("CodeCompanion not loaded yet", vim.log.levels.WARN)
          return
        end

        -- Get the current chat
        local chat = CodeCompanion.last_chat()
        if not chat then
          vim.notify("No active chat. Open a chat first with <leader>ac", vim.log.levels.WARN)
          return
        end

        -- Check current adapter and toggle
        local current_adapter = chat.adapter.name

        if current_adapter == "claude_code" then
          -- Switch to regular anthropic
          chat:change_adapter("anthropic")
          vim.notify("Switched to Chat mode (Anthropic)", vim.log.levels.INFO)
        else
          -- Switch to claude_code (agentic)
          chat:change_adapter("claude_code")
          vim.notify("Switched to Agentic mode (Claude Code)", vim.log.levels.INFO)
        end
      end,
      desc = "Toggle AI Plan/Act Mode"
    },
  },

  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "anthropic", -- Default to regular chat mode
        },
        inline = {
          adapter = "anthropic",
        },
      },
      adapters = {
        http = {
          anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = {
                api_key = "ANTHROPIC_API_KEY",
              },
              schema = {
                model = {
                  default = "claude-sonnet-4-20250514",
                },
                extended_thinking = {
                  default = false, -- Disabled by default, toggle with <leader>at
                },
                thinking_budget = {
                  default = 16000,
                },
              },
            })
          end,
        },
        acp = {
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {
              env = {
                -- Use API key method (simpler than OAuth)
                ANTHROPIC_API_KEY = "cmd:echo $ANTHROPIC_API_KEY 2>/dev/null || echo ''",
              },
            })
          end,
        },
      },
      display = {
        chat = {
          window = {
            layout = "vertical", -- vertical | horizontal | float
            width = 0.4,
            height = 0.8,
            border = "rounded",
          },
        },
      },
    })
  end,
}
