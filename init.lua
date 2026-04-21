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

-- Load core config (options sets leader keys)
require("config.options")

-- Build hooks for plugins that need compilation. Must be registered BEFORE
-- vim.pack.add so hooks fire on first install.
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("pack_build_hooks", { clear = true }),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= "install" and kind ~= "update" then
      return
    end

    if name == "telescope-fzf-native.nvim" and vim.fn.executable("make") == 1 then
      vim.system({ "make" }, { cwd = ev.data.path }):wait()
    end

    if name == "nvim-treesitter" and kind == "update" and vim.fn.executable("tree-sitter") == 1 then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      require("nvim-treesitter").update()
    end

    if name == "LuaSnip" and vim.fn.executable("make") == 1 then
      vim.system({ "make", "install_jsregexp" }, { cwd = ev.data.path }):wait()
    end

    if name == "mason.nvim" then
      if not ev.data.active then
        vim.cmd.packadd("mason.nvim")
      end
      vim.cmd("MasonUpdate")
    end

    if name == "molten-nvim" then
      vim.cmd("UpdateRemotePlugins")
    end
  end,
})

-- All plugins managed by vim.pack (Nvim 0.12+ native manager).
-- Plugin setup lives in plugin/<name>.lua (auto-sourced after init.lua).
vim.pack.add({
  -- Colorscheme (first — highlights must be available for all other plugins)
  "https://github.com/catppuccin/nvim",

  -- Shared libraries
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/MunifTanjim/nui.nvim",

  -- Simple leaf plugins
  "https://github.com/sphamba/smear-cursor.nvim",
  "https://github.com/declancm/cinnamon.nvim",
  "https://github.com/NvChad/nvim-colorizer.lua",
  "https://github.com/echasnovski/mini.surround",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/kawre/neotab.nvim",
  "https://github.com/RRethy/vim-illuminate",
  "https://github.com/echasnovski/mini.bufremove",
  "https://github.com/echasnovski/mini.indentscope",
  "https://github.com/lukas-reineke/indent-blankline.nvim",
  "https://github.com/luukvbaal/statuscol.nvim",
  "https://github.com/folke/todo-comments.nvim",
  "https://github.com/b0o/schemastore.nvim",

  -- UI
  "https://github.com/rcarriga/nvim-notify",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/Bekaboo/dropbar.nvim",
  "https://github.com/folke/noice.nvim",

  -- Git + diagnostics
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/sindrets/diffview.nvim",
  "https://github.com/folke/trouble.nvim",
  "https://github.com/kevinhwang91/promise-async",
  "https://github.com/kevinhwang91/nvim-ufo",
  "https://github.com/saxon1964/neovim-tips",

  -- Markup / display
  "https://github.com/OXY2DEV/markview.nvim",
  "https://github.com/3rd/image.nvim",

  -- External integrations
  "https://github.com/pwntester/octo.nvim",
  "https://github.com/Willem-J-an/adopure.nvim",
  "https://github.com/coder/claudecode.nvim",
  "https://github.com/mistweaverco/kulala.nvim",
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },

  -- Telescope + extensions
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
  "https://github.com/nvim-telescope/telescope-ui-select.nvim",

  -- Treesitter
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },

  -- Completion
  "https://github.com/rafamadriz/friendly-snippets",
  { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("2.x") },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },

  -- Mason
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",

  -- Linting + formatting
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/mfussenegger/nvim-lint",
  "https://gitlab.com/schrieveslaach/sonarlint.nvim",

  -- DAP
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/rcarriga/nvim-dap-ui",

  -- Language-specific
  "https://github.com/seblyng/roslyn.nvim",
  "https://github.com/khoido2003/roslyn-filewatch.nvim",
  "https://github.com/mfussenegger/nvim-jdtls",
  "https://github.com/Kurren123/mssql.nvim",

  -- Jupyter
  { src = "https://github.com/benlubas/molten-nvim", version = vim.version.range("1.x") },
})

-- Load core modules
require("config.keymaps")
require("config.autocmds")
