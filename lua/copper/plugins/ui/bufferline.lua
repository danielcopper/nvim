local icons = require("copper.config.icons")

return {
  {
    "akinsho/nvim-bufferline.lua",
    enabled = true,
    event = "VeryLazy",
    dependencies = {
      { 'ojroques/nvim-bufdel' },
    },
    opts = {
      options = {
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            separator = true,
            text_align = "center"
          },
          {
            filetype = "NvimTree",
            text = "File Explorer",
            separator = true,
            text_align = "center"
          },
        },
        separator_style = "thin", -- "slant" | "thick" | "thin" | { 'any', 'any' },
        -- show_tab_indicators = true,
        always_show_bufferline = false,
        diagnostics = "nvim_lsp",
        -- diagnostics_indicator = function(count, level, diagnostics_dict, context)
        --   local icon = level:match("error") and icons.diagnostics.Error or icons.diagnostics.Warning
        --   return " " .. icon .. count
        -- end,
        diagnostics_indicator = function(_, _, diag)
          local ret = (diag.error and icons.diagnostics.Error .. diag.error .. " " or "")
              .. (diag.warning and icons.diagnostics.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        color_icons = true,
        show_buffer_icons = true,
        hover = {
          enabled = true,
          delay = 0,
          reveal = { "close" },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      require("bufdel").setup({
        quit = false, -- quit Neovim when last buffer is closed
      })
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd("BufAdd", {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
    keys = {
      { "<S-h>",       "<cmd>BufferLineCyclePrev<cr>",            { desc = "Move to Prev buffer" } },
      { "<S-l>",       "<cmd>BufferLineCycleNext<cr>",            { desc = "Move to Next buffer" } },
      { "<A-,>",       "<Cmd>BufferLineCyclePrev<CR>",            { desc = "Move to Prev buffer", remap = true } },
      { "<A-.>",       "<Cmd>BufferLineCycleNext<CR>",            { desc = "Move to Next buffer", remap = true } },
      { "<A-<>",       "<Cmd>BufferLineMovePrev<CR>",             { desc = "Move buffer to the left" } },
      { "<A->>",       "<Cmd>BufferLineMoveNext<CR>",             { desc = "Move Buffer to the right" } },
      { "<A-1>",       "<Cmd>BufferLineGoTo 1<CR>",               { desc = "Goto Buffer number 9" } },
      { "<A-2>",       "<Cmd>BufferLineGoTo 2<CR>",               { desc = "Goto Buffer number 9" } },
      { "<A-3>",       "<Cmd>BufferLineGoTo 3<CR>",               { desc = "Goto Buffer number 9" } },
      { "<A-4>",       "<Cmd>BufferLineGoTo 4<CR>",               { desc = "Goto Buffer number 9" } },
      { "<A-5>",       "<Cmd>BufferLineGoTo 5<CR>",               { desc = "Goto Buffer number 9" } },
      { "<A-6>",       "<Cmd>BufferLineGoTo 6<CR>",               { desc = "Goto Buffer number 9" } },
      { "<A-7>",       "<Cmd>BufferLineGoTo 7<CR>",               { desc = "Goto Buffer number 9" } },
      { "<A-8>",       "<Cmd>BufferLineGoTo 8<CR>",               { desc = "Goto Buffer number 9" } },
      { "<A-9>",       "<Cmd>BufferLineGoTo 9<CR>",               { desc = "Goto Buffer number 9" } },
      { "<A-p>",       "<Cmd>BufferLineTogglePin<CR>",            { desc = "Pin current Buffer" } },
      { "<C-p>",       "<Cmd>BufferLineGoToBuffer<CR>",           { desc = "Pick Buffer to jump to" } },
      -- NOTE: Stopped working suddenly...
      { "<A-c>",       ":BufDel",                                 { desc = "Close current Buffer" } },
      { "<A-d>",       "<Cmd>BufDel<CR>",                         { desc = "Close current Buffer" } },
      { "<leader>bd",  "<Cmd>BufDel<CR>",                         { desc = "Close current Buffer" } },
      { "<leader>bca", "<C-w>h <bar> <Cmd>BufDelOthers<CR>",      { desc = "Close all Buffers but File Explorer" }, },
      { "<leader>bcA", "<Cmd>BufDelAll<CR>",                      { desc = "Close all Buffers" } },
      { "<leader>bco", "<Cmd>BufDelOthers<CR>",                   { desc = "Close all but current Buffer" } },
      { "<leader>bcu", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Close unpinned Buffers" } },
    },
  },
}
