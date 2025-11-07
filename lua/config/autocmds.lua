local function augroup(name)
  return vim.api.nvim_create_augroup("config_" .. name, { clear = true })
end

-- Highlight when yanking text (disabled in favor of tiny-glimmer.nvim)
-- vim.api.nvim_create_autocmd("TextYankPost", {
--   group = augroup("highlight_yank"),
--   callback = function()
--     vim.highlight.on_yank({ timeout = 200, visual = true })
--   end,
-- })

-- Restore cursor position with centering
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("restore_cursor"),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
      vim.schedule(function()
        vim.cmd("normal! zz")
      end)
    end
  end,
})

-- Check if files changed outside Neovim
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- Auto resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  command = "wincmd =",
})

-- Enable spell and wrap for text files
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("text_files"),
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Close certain windows with 'q'
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = { "help", "lspinfo", "man", "qf", "checkhealth" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("vertical_help"),
  pattern = "help",
  command = "wincmd L",
})

-- Syntax highlighting for dotenv files
vim.api.nvim_create_autocmd("BufRead", {
  group = augroup("dotenv_ft"),
  pattern = { ".env", ".env.*" },
  callback = function()
    vim.bo.filetype = "dosini"
  end,
})

-- Show cursorline only in active window
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = augroup("active_cursorline"),
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = augroup("active_cursorline"),
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

-- Auto-delete empty unnamed buffers when opening a file
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = augroup("delete_empty_buffer"),
  callback = function(args)
    if args.file == "" then
      return
    end

    vim.schedule(function()
      local buffers = vim.api.nvim_list_bufs()
      local valid_buffers = 0

      for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then
          valid_buffers = valid_buffers + 1
        end
      end

      if valid_buffers > 0 then
        for _, buf in ipairs(buffers) do
          if vim.api.nvim_buf_is_valid(buf) then
            local name = vim.api.nvim_buf_get_name(buf)
            local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
            local modified = vim.api.nvim_buf_get_option(buf, "modified")

            if (name == "" or name == "." or vim.fn.isdirectory(name) == 1) and buftype == "" and not modified then
              local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
              local char_count = 0
              for _, line in ipairs(lines) do
                char_count = char_count + #line
              end

              if char_count == 0 then
                pcall(vim.api.nvim_buf_delete, buf, { force = true })
              end
            end
          end
        end
      end
    end)
  end,
})
