-- TODO:
-- code actions are still bordered
-- lazygit borderles
local function load_env()
  local env_file = vim.fn.stdpath("config") .. "/.env"
  if vim.fn.filereadable(env_file) == 1 then
    for line in io.lines(env_file) do
      -- Skip empty lines and comments
      if line:match("^%s*$") == nil and line:match("^%s*#") == nil then
        local key, value = line:match("^([%w_]+)%s*=%s*(.+)$")
        if key and value then
          -- Remove quotes if present
          value = value:gsub("^['\"]", ""):gsub("['\"]$", "")
          vim.env[key] = value
        end
      end
    end
  end
end
load_env()

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load core config (options sets leader keys)
require("config.options")

-- Plugins that should load in VSCode (whitelist approach)
local vscode_enabled = {
  "lazy.nvim",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "nvim-surround",
  "nvim-autopairs",
  "which-key.nvim",
}

-- Setup plugins
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    cond = function(plugin)
      -- Always load outside VSCode
      if not vim.g.vscode then return true end
      -- In VSCode: only load whitelisted plugins or those marked vscode=true
      return vim.tbl_contains(vscode_enabled, plugin.name) or plugin.vscode
    end,
  },
  install = { colorscheme = { "catppuccin", "habamax" } },
  checker = { enabled = not vim.g.vscode, notify = true },
  change_detection = { enabled = not vim.g.vscode, notify = false },
  -- ui = { border = "rounded" },
})

-- Load keymaps and autocmds
require("config.keymaps")
require("config.autocmds")

-- Load VSCode-specific config when running in VSCode
if vim.g.vscode then
  require("config.vscode")
else
  -- Apply custom theme highlights after colorscheme loads (not needed in VSCode)
  require("config.theme.highlights").setup()
end
