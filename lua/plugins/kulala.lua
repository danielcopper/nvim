-- Kulala: HTTP client for .http files (endpoint testing)

return {
  "mistweaverco/kulala.nvim",
  ft = "http",
  keys = {
    { "<leader>rr", function() require("kulala").run() end, desc = "Run request" },
    { "<leader>ra", function() require("kulala").run_all() end, desc = "Run all requests" },
    { "<leader>rn", function() require("kulala").jump_next() end, desc = "Next request" },
    { "<leader>rp", function() require("kulala").jump_prev() end, desc = "Previous request" },
    { "<leader>re", function() require("kulala").set_selected_env() end, desc = "Select environment" },
    { "<leader>ri", function() require("kulala").inspect() end, desc = "Inspect request" },
    { "<leader>rc", function() require("kulala").copy() end, desc = "Copy as cURL" },
    { "<leader>rt", function() require("kulala").toggle_view() end, desc = "Toggle body/headers" },
  },
  opts = {
    request_timeout = 30000,
    additional_curl_options = { "--insecure" },
    ui = {
      display_mode = "float",
      default_view = "body",
      max_response_size = 1048576,
    },
  },
  config = function(_, opts)
    require("kulala").setup(opts)

    -- Prevent duplicate kulala LSP clients on worktree switches.
    -- Kulala creates a new cmd closure per start_lsp() call, so vim.lsp.start()
    -- cannot deduplicate. Replace the autocmd with one that guards against dupes.
    pcall(vim.api.nvim_del_augroup_by_name, "Kulala filetype setup")
    local kulala_starting = false
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("Kulala filetype setup", { clear = true }),
      pattern = require("kulala.config").options.lsp.filetypes,
      callback = function(ev)
        if not require("kulala.config").options.lsp.enable then return end
        -- Reuse any existing non-stopped client
        for _, c in ipairs(vim.lsp.get_clients({ name = "kulala" })) do
          if not c:is_stopped() then
            vim.lsp.buf_attach_client(ev.buf, c.id)
            return
          end
        end
        -- Prevent concurrent starts (e.g. remap_buffers triggering multiple FileType events)
        if kulala_starting then return end
        kulala_starting = true
        vim.defer_fn(function() kulala_starting = false end, 100)
        require("kulala.cmd.lsp").start(ev.buf, ev.match)
      end,
    })
  end,
}
