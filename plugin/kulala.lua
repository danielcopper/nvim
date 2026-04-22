vim.pack.add({ "https://github.com/mistweaverco/kulala.nvim" })

require("kulala").setup({
  request_timeout = 30000,
  additional_curl_options = { "--insecure" },
  ui = {
    display_mode = "float",
    default_view = "body",
    max_response_size = 100 * 1024 * 1024,
    win_opts = {},
  },
})

-- Float window: 70% of editor, centered, updates on resize
local cfg = require("kulala.config").options
local function update_float_size()
  local w = math.floor(vim.o.columns * 0.7)
  local h = math.floor(vim.o.lines * 0.7)
  local wo = cfg.ui.win_opts
  wo.width = w
  wo.height = h
  wo.row = math.floor((vim.o.lines - h) / 2) - 1
  wo.col = math.floor((vim.o.columns - w) / 2)
end
update_float_size()
vim.api.nvim_create_autocmd("VimResized", { callback = update_float_size })

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
    for _, c in ipairs(vim.lsp.get_clients({ name = "kulala" })) do
      if not c:is_stopped() then
        vim.lsp.buf_attach_client(ev.buf, c.id)
        return
      end
    end
    if kulala_starting then return end
    kulala_starting = true
    vim.defer_fn(function() kulala_starting = false end, 100)
    require("kulala.cmd.lsp").start(ev.buf, ev.match)
  end,
})

-- Keymaps
vim.keymap.set("n", "<leader>rr", function() require("kulala").run() end, { desc = "Run request" })
vim.keymap.set("n", "<leader>ra", function() require("kulala").run_all() end, { desc = "Run all requests" })
vim.keymap.set("n", "<leader>rn", function() require("kulala").jump_next() end, { desc = "Next request" })
vim.keymap.set("n", "<leader>rp", function() require("kulala").jump_prev() end, { desc = "Previous request" })
vim.keymap.set("n", "<leader>re", function() require("kulala").set_selected_env() end, { desc = "Select environment" })
vim.keymap.set("n", "<leader>ri", function() require("kulala").inspect() end, { desc = "Inspect request" })
vim.keymap.set("n", "<leader>rc", function() require("kulala").copy() end, { desc = "Copy as cURL" })
vim.keymap.set("n", "<leader>rt", function() require("kulala").toggle_view() end, { desc = "Toggle body/headers" })

vim.keymap.set("n", "<leader>ro", function()
  local globals = require("kulala.globals")
  local headers_file = globals.HEADERS_FILE
  local body_file = globals.BODY_FILE

  local headers = vim.fn.readfile(headers_file)
  local filename
  for _, line in ipairs(headers) do
    if line:lower():match("content%-disposition") then
      filename = line:match('[; ]filename%s*=%s*"([^"]+)"')
      if not filename then filename = line:match("[; ]filename%s*=%s*([^;%s]+)") end
      if filename then break end
    end
  end

  if not filename then
    filename = "response_" .. os.date("%Y%m%d_%H%M%S") .. ".bin"
    vim.notify("No filename in headers, using: " .. filename, vim.log.levels.WARN)
  end

  local is_wsl = vim.fn.has("wsl") == 1 or vim.fn.filereadable("/proc/sys/fs/binfmt_misc/WSLInterop") == 1
  local is_mac = vim.fn.has("mac") == 1

  if is_wsl then
    local win_home = os.getenv("USERPROFILE") or "/mnt/c/Users"
    local dest = win_home .. "/Downloads/" .. filename
    vim.fn.system({ "cp", body_file, dest })
    if vim.v.shell_error == 0 then
      local win_path = vim.fn.system({ "wslpath", "-w", dest }):gsub("%s+$", "")
      vim.fn.jobstart({ "cmd.exe", "/C", "start", '""', win_path }, { detach = true })
      vim.notify("Opened: " .. filename, vim.log.levels.INFO)
    else
      vim.notify("Failed to copy to " .. dest, vim.log.levels.ERROR)
    end
  elseif is_mac then
    local dest = "/tmp/" .. filename
    vim.fn.system({ "cp", body_file, dest })
    vim.fn.jobstart({ "open", dest }, { detach = true })
    vim.notify("Opened: " .. filename, vim.log.levels.INFO)
  else
    local dest = "/tmp/" .. filename
    vim.fn.system({ "cp", body_file, dest })
    vim.fn.jobstart({ "xdg-open", dest }, { detach = true })
    vim.notify("Opened: " .. filename, vim.log.levels.INFO)
  end
end, { desc = "Open response with default app" })
