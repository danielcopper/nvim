-- CodeCompanion: AI-powered coding assistant with Claude integration

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
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI Chat Toggle" },
    { "<leader>at", function()
      -- Toggle extended thinking mode
      local config = require("codecompanion").config
      local adapter = config.adapters.http.anthropic
      local current = adapter.schema.extended_thinking or false
      adapter.schema.extended_thinking = not current
      vim.notify(
        "Extended thinking: " .. (adapter.schema.extended_thinking and "ON" or "OFF"),
        vim.log.levels.INFO
      )
    end, desc = "Toggle AI Thinking Mode" },
    { "<leader>ap", function()
      -- Toggle between chat and agentic mode by changing adapter
      local codecompanion = require("codecompanion")
      local config = codecompanion.config

      -- Check if we're using acp adapter
      local using_acp = config.strategies.chat.adapter == "claude_code"

      if using_acp then
        -- Switch to regular anthropic
        config.strategies.chat.adapter = "anthropic"
        config.strategies.inline.adapter = "anthropic"
        vim.notify("Switched to Chat mode (Anthropic)", vim.log.levels.INFO)
      else
        -- Switch to claude_code (agentic)
        config.strategies.chat.adapter = "claude_code"
        config.strategies.inline.adapter = "claude_code"
        vim.notify("Switched to Agentic mode (Claude Code)", vim.log.levels.INFO)
      end
    end, desc = "Toggle AI Plan/Act Mode" },
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
