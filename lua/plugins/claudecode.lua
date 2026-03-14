-- Claude Code: Official Claude AI integration for Neovim
-- Implements the same WebSocket-based MCP protocol as VS Code extension

return {
  "coder/claudecode.nvim",
  dependencies = {},
  event = "VeryLazy",

  keys = {
    -- Main Claude Code commands
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code", mode = { "n", "v" } },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude Code", mode = { "n", "v" } },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude Model", mode = "n" },
    { "<leader>ar", "<cmd>ClaudeCodeRestart<cr>", desc = "Restart Claude Server", mode = "n" },

    -- Context management
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", desc = "Send Selection to Claude", mode = "v" },
    {
      "<leader>aa",
      function()
        local file = vim.fn.expand("%:p")
        if file ~= "" then
          vim.cmd("ClaudeCodeAdd " .. file)
          vim.notify("Added " .. vim.fn.expand("%:t") .. " to Claude context", vim.log.levels.INFO)
        else
          vim.notify("No file to add", vim.log.levels.WARN)
        end
      end,
      desc = "Add Current File to Claude",
      mode = "n",
    },

    -- Diff management
    { "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept/Yes Diff", mode = "n" },
    { "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny/No Diff", mode = "n" },
  },

  opts = {
    -- Server settings
    auto_start = true,
    log_level = "info", -- "trace", "debug", "info", "warn", "error"

    -- Terminal configuration
    terminal = {
      provider = "native",
      split_side = "right",
      split_width_percentage = 0.35,
      auto_close = false,
    },

    -- Diff settings
    diff_opts = {
      layout = "vertical",
      open_in_new_tab = true, -- Open in new tab to preserve current window layout
      keep_terminal_focus = false,
      hide_terminal_in_new_tab = false,
    },

    -- Working directory (uses git root by default)
    git_repo_cwd = true,

    -- Use default claude command (configure auth with 'claude setup-token')
  },

  config = function(_, opts)
    require("claudecode").setup(opts)

    -- Auto-enter insert mode when navigating to Claude terminal
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "term://*claude*",
      callback = function()
        vim.cmd("startinsert")
      end,
      desc = "Auto-enter insert mode in Claude terminal",
    })

    -- Optional: Add file tree integration for Neo-tree
    -- When you press <leader>as on a file in Neo-tree, it adds it to Claude context
    local neo_tree_ok, _ = pcall(require, "neo-tree")
    if neo_tree_ok then
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "neo-tree",
        callback = function()
          vim.keymap.set("n", "<leader>as", function()
            local state = require("neo-tree.sources.manager").get_state("filesystem")
            local node = state.tree:get_node()
            if node and node.path then
              vim.cmd("ClaudeCodeAdd " .. node.path)
              vim.notify("Added to Claude: " .. vim.fn.fnamemodify(node.path, ":t"), vim.log.levels.INFO)
            end
          end, { buffer = true, desc = "Add to Claude Context" })
        end,
      })
    end
  end,
}
