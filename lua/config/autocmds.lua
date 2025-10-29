-- Autocommands

local function augroup(name)
  return vim.api.nvim_create_augroup("config_" .. name, { clear = true })
end

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("restore_cursor"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Check if files changed outside Neovim
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- Resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
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

-- Start terminal in insert mode
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("terminal"),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd("startinsert")
  end,
})

-- Auto-delete empty unnamed buffers when opening a file
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = augroup("delete_empty_buffer"),
  callback = function(args)
    -- Don't run if we're opening the initial buffer
    if args.file == "" then
      return
    end

    vim.schedule(function()
      -- Get all buffers
      local buffers = vim.api.nvim_list_bufs()
      local valid_buffers = 0

      -- Count valid buffers (with content)
      for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then
          valid_buffers = valid_buffers + 1
        end
      end

      -- Only clean up if we have at least one valid buffer
      if valid_buffers > 0 then
        for _, buf in ipairs(buffers) do
          if vim.api.nvim_buf_is_valid(buf) then
            local name = vim.api.nvim_buf_get_name(buf)
            local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
            local modified = vim.api.nvim_buf_get_option(buf, "modified")

            -- Check if buffer is empty, unnamed, or just a directory
            if (name == "" or name == "." or vim.fn.isdirectory(name) == 1) and buftype == "" and not modified then
              local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
              local char_count = 0
              for _, line in ipairs(lines) do
                char_count = char_count + #line
              end

              -- Delete if truly empty (only whitespace/empty lines)
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
