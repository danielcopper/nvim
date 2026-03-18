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

-- Auto-download missing spell files when spell is first enabled
-- SpellFileMissing doesn't fire when spell is set programmatically,
-- so we check when opening text files (where spell gets enabled).
do
  local spell_prompted = false
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("spell_download"),
    pattern = { "gitcommit", "markdown", "text" },
    callback = function()
      if spell_prompted then return end

      local spell_dir = vim.fn.stdpath("config") .. "/spell"
      if vim.fn.isdirectory(spell_dir) == 0 then
        vim.fn.mkdir(spell_dir, "p")
      end

      local wanted = { "de" }
      local missing = {}
      for _, lang in ipairs(wanted) do
        if vim.fn.filereadable(spell_dir .. "/" .. lang .. ".utf-8.spl") == 0 then
          table.insert(missing, lang)
        end
      end
      if #missing == 0 then return end
      spell_prompted = true

      local base_url = "https://ftp.nluug.nl/pub/vim/runtime/spell"

      vim.defer_fn(function()
        vim.ui.select(missing, {
          prompt = "Download missing spell files?",
          format_item = function(lang)
            return lang .. " (utf-8)"
          end,
        }, function(lang)
          if not lang then return end
          for _, ext in ipairs({ "spl", "sug" }) do
            local name = lang .. ".utf-8." .. ext
            local url = base_url .. "/" .. name
            local pth = spell_dir .. "/" .. name
            vim.notify("Downloading " .. name .. "...", vim.log.levels.INFO)
            vim.system({ "curl", "-fLo", pth, url }, {}, function(result)
              vim.schedule(function()
                if result.code == 0 then
                  vim.notify("Downloaded " .. name, vim.log.levels.INFO)
                  if ext == "spl" then
                    vim.opt.spelllang:append(lang)
                  end
                else
                  vim.notify("Failed to download " .. name, vim.log.levels.ERROR)
                end
              end)
            end)
          end
        end)
      end, 500)
    end,
  })
end

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
  callback = function(args)
    -- Only move to right split if this is actually a help buffer
    if vim.bo[args.buf].buftype == "help" then
      vim.cmd("wincmd L")
    end
  end,
})

-- Syntax highlighting for dotenv files
vim.api.nvim_create_autocmd("BufRead", {
  group = augroup("dotenv_ft"),
  pattern = { ".env", ".env.*" },
  callback = function()
    vim.bo.filetype = "dosini"
  end,
})

-- Disable heavy features for large files
vim.api.nvim_create_autocmd("BufReadPre", {
  group = augroup("bigfile"),
  callback = function(args)
    local max_filesize = 1024 * 1024 -- 1 MB
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > max_filesize then
      vim.b[args.buf].bigfile = true
      vim.opt_local.syntax = ""
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.foldmethod = "manual"
      vim.schedule(function()
        pcall(vim.treesitter.stop, args.buf)
      end)
    end
  end,
})

-- Cursorline stays visible in all windows (shows cursor position in inactive splits)

-- -- Auto-delete empty unnamed buffers when opening a file
-- vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
--   group = augroup("delete_empty_buffer"),
--   callback = function(args)
--     if args.file == "" then
--       return
--     end
--
--     vim.schedule(function()
--       local buffers = vim.api.nvim_list_bufs()
--       local valid_buffers = 0
--
--       for _, buf in ipairs(buffers) do
--         if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then
--           valid_buffers = valid_buffers + 1
--         end
--       end
--
--       if valid_buffers > 0 then
--         for _, buf in ipairs(buffers) do
--           if vim.api.nvim_buf_is_valid(buf) then
--             local name = vim.api.nvim_buf_get_name(buf)
--             local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
--             local modified = vim.api.nvim_buf_get_option(buf, "modified")
--
--             if (name == "" or name == "." or vim.fn.isdirectory(name) == 1) and buftype == "" and not modified then
--               local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
--               local char_count = 0
--               for _, line in ipairs(lines) do
--                 char_count = char_count + #line
--               end
--
--               if char_count == 0 then
--                 pcall(vim.api.nvim_buf_delete, buf, { force = true })
--               end
--             end
--           end
--         end
--       end
--     end)
--   end,
-- })
