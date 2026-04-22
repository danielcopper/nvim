local function load_env()
  local env_file = vim.fn.stdpath("config") .. "/.env"
  if vim.fn.filereadable(env_file) == 1 then
    for line in io.lines(env_file) do
      if line:match("^%s*$") == nil and line:match("^%s*#") == nil then
        local key, value = line:match("^([%w_]+)%s*=%s*(.+)$")
        if key and value then
          value = value:gsub("^['\"]", ""):gsub("['\"]$", "")
          vim.env[key] = value
        end
      end
    end
  end
end
load_env()

require("config.options")
require("config.keymaps")
require("config.autocmds")
