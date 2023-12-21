return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = vim.opt.sessionoptions:get() },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
    },
  },

  -- TODO:Decide on one and also check out: https://github.com/Shatur/neovim-session-manager
  -- maybe pick one that uses the builtin makesession
  -- {
  --   "jedrzejboczar/possession.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   opts = {
  --     autosave = {
  --       current = true,
  --     },
  --   },
  --   keys = { { "<leader>tsm", "<CMD>Telescope possession list<CR>", desc = "[F]ind [S]essions" } },
  --   cmd = { "PossessionSave" },
  -- },
  --
  -- {
  --   "coffebar/neovim-project",
  --   lazy = true,
  --   enabled = false,
  --   priority = 100,
  --   init = function()
  --     -- enable saving the state of plugins in the session
  --     vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
  --   end,
  --   dependencies = {
  --     { "nvim-lua/plenary.nvim" },
  --     { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
  --     { "Shatur/neovim-session-manager" },
  --   },
  --   opts = {
  --     -- Project directories
  --     projects = {
  --       "~/projects/*",
  --       "~/p*cts/*", -- glob pattern is supported
  --       "~/projects/repos/*",
  --       "~/.config/*",
  --       "~/work/*",
  --     },
  --     -- Path to store history and sessions
  --     datapath = vim.fn.stdpath("data"), -- ~/.local/share/nvim/
  --     -- Load the most recent session on startup if not in the project directory
  --     last_session_on_startup = false,
  --
  --     -- Overwrite some of Session Manager options
  --     session_manager_opts = {
  --       autosave_ignore_dirs = {
  --         vim.fn.expand("~"), -- don't create a session for $HOME/
  --         "/tmp",
  --       },
  --       autosave_ignore_filetypes = {
  --         -- All buffers of these file types will be closed before the session is saved
  --         "ccc-ui",
  --         "gitcommit",
  --         "gitrebase",
  --         "qf",
  --         "toggleterm",
  --       },
  --     },
  --   },
  --   keys = {
  --     { "<leader>tp",  "<Cmd>Telescope neovim-project discover<CR>", desc = "Telescope discover projects" },
  --     { "<leader>tph", "<Cmd>Telescope neovim-project history<CR>",  desc = "Telescope projects history" },
  --     { "<leader>lrp", "<Cmd>NeovimProjectLoadRecent<CR>",           desc = "Load Recent Project" },
  --   },
  -- }
}
