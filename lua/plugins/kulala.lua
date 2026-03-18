-- Kulala: HTTP client for .http files (endpoint testing)

return {
  "mistweaverco/kulala.nvim",
  ft = "http",
  keys = {
    { "<leader>hr", function() require("kulala").run() end, desc = "Run request" },
    { "<leader>ha", function() require("kulala").run_all() end, desc = "Run all requests" },
    { "<leader>hn", function() require("kulala").jump_next() end, desc = "Next request" },
    { "<leader>hp", function() require("kulala").jump_prev() end, desc = "Previous request" },
    { "<leader>he", function() require("kulala").set_selected_env() end, desc = "Select environment" },
    { "<leader>hi", function() require("kulala").inspect() end, desc = "Inspect request" },
    { "<leader>hc", function() require("kulala").copy() end, desc = "Copy as cURL" },
    { "<leader>ht", function() require("kulala").toggle_view() end, desc = "Toggle body/headers" },
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
}
