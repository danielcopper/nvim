-- Treesitter: Advanced syntax highlighting and code understanding

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },

  main = "nvim-treesitter.configs",
  opts = {
    -- Auto-install parsers for these languages
    ensure_installed = {
      "bash",
      "c",
      "c_sharp",
      "css",
      "diff",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "sql",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = true,

    -- Syntax highlighting
    highlight = {
      enable = true,
      -- Disable for very large files
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
    },

    -- Indentation based on treesitter
    indent = { enable = true },

    -- Incremental selection
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },

    -- Text objects
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj
        keymaps = {
          -- Functions
          ["af"] = { query = "@function.outer", desc = "Select around function" },
          ["if"] = { query = "@function.inner", desc = "Select inside function" },

          -- Classes
          ["ac"] = { query = "@class.outer", desc = "Select around class" },
          ["ic"] = { query = "@class.inner", desc = "Select inside class" },

          -- Parameters/arguments
          ["aa"] = { query = "@parameter.outer", desc = "Select around argument" },
          ["ia"] = { query = "@parameter.inner", desc = "Select inside argument" },

          -- Conditionals
          ["ai"] = { query = "@conditional.outer", desc = "Select around conditional" },
          ["ii"] = { query = "@conditional.inner", desc = "Select inside conditional" },

          -- Loops
          ["al"] = { query = "@loop.outer", desc = "Select around loop" },
          ["il"] = { query = "@loop.inner", desc = "Select inside loop" },

          -- Blocks
          ["ab"] = { query = "@block.outer", desc = "Select around block" },
          ["ib"] = { query = "@block.inner", desc = "Select inside block" },
        },
      },

      -- Move between text objects
      move = {
        enable = true,
        set_jumps = true, -- Add to jumplist
        goto_next_start = {
          ["]f"] = { query = "@function.outer", desc = "Next function start" },
          ["]c"] = { query = "@class.outer", desc = "Next class start" },
          ["]a"] = { query = "@parameter.inner", desc = "Next argument" },
        },
        goto_next_end = {
          ["]F"] = { query = "@function.outer", desc = "Next function end" },
          ["]C"] = { query = "@class.outer", desc = "Next class end" },
        },
        goto_previous_start = {
          ["[f"] = { query = "@function.outer", desc = "Previous function start" },
          ["[c"] = { query = "@class.outer", desc = "Previous class start" },
          ["[a"] = { query = "@parameter.inner", desc = "Previous argument" },
        },
        goto_previous_end = {
          ["[F"] = { query = "@function.outer", desc = "Previous function end" },
          ["[C"] = { query = "@class.outer", desc = "Previous class end" },
        },
      },
    },
  },
}
