-- Jupyter Notebook support for Neovim
-- Provides inline code execution, output display, and seamless .ipynb/.py conversion

return {
  -- Inline notebook execution with output display (like VSCode/JupyterLab)
  -- Requires: Python provider enabled, kitty/wezterm/ghostty terminal for image support
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    ft = { "python", "jupyter" },

    init = function()
      -- Output window configuration
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = true
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true

      -- Don't auto-show output for every cell (can be noisy)
      vim.g.molten_auto_open_output = false

      -- Use borders for output windows
      vim.g.molten_output_win_border = { "", "─", "", "" }
    end,

    keys = {
      -- Initialize kernel
      { "<leader>ji", ":MoltenInit<cr>", desc = "Initialize Molten", silent = true },

      -- Evaluate code
      { "<leader>je", ":MoltenEvaluateOperator<cr>", desc = "Evaluate Operator", silent = true },
      { "<leader>jl", ":MoltenEvaluateLine<cr>", desc = "Evaluate Line", silent = true },
      { "<leader>jc", ":MoltenReevaluateCell<cr>", desc = "Re-evaluate Cell", silent = true },
      { "<leader>jr", ":MoltenEvaluateVisual<cr>gv", desc = "Evaluate Visual", mode = "v", silent = true },

      -- Output management
      { "<leader>jo", ":MoltenShowOutput<cr>", desc = "Show Output", silent = true },
      { "<leader>jh", ":MoltenHideOutput<cr>", desc = "Hide Output", silent = true },
      { "<leader>jd", ":MoltenDelete<cr>", desc = "Delete Cell", silent = true },

      -- Navigation
      { "]j", ":MoltenNext<cr>", desc = "Next Cell", silent = true },
      { "[j", ":MoltenPrev<cr>", desc = "Previous Cell", silent = true },

      -- Interrupt/restart
      { "<leader>jx", ":MoltenInterrupt<cr>", desc = "Interrupt Execution", silent = true },
      { "<leader>jR", ":MoltenRestart!<cr>", desc = "Restart Kernel", silent = true },
    },
  },

  -- Convert between .ipynb and .py formats (better git diffs)
  {
    "GCBallesteros/jupytext.nvim",
    config = function()
      require("jupytext").setup({
        style = "percent", -- Use "# %%" style cell markers
        output_extension = "py", -- Convert notebooks to .py files
        force_ft = "python", -- Set filetype to python

        custom_language_formatting = {
          python = {
            extension = "py",
            style = "percent",
            force_ft = "python",
          },
          -- Add other languages if needed
          -- julia = {
          --   extension = "jl",
          --   style = "percent",
          --   force_ft = "julia",
          -- },
        },
      })
    end,
  },

  -- Image display support for molten
  -- Requires: kitty/wezterm/ghostty terminal with image protocol support
  {
    "3rd/image.nvim",
    cond = vim.env.TERM_PROGRAM == "WezTerm" or vim.env.TERM == "xterm-kitty" or vim.env.TERM_PROGRAM == "ghostty",
    opts = {
      backend = "kitty", -- or "ueberzug"
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
        },
      },
      max_width = 100,
      max_height = 12,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },
}
