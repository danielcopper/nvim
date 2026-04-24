local function augroup(name)
  return vim.api.nvim_create_augroup("config_" .. name, { clear = true })
end

-- vim.pack build hooks. Registered before vim.pack.add() in init.lua so
-- they fire on first install.
vim.api.nvim_create_autocmd("PackChanged", {
  group = augroup("pack_build_hooks"),
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
      if vim.fn.exists(":MasonUpdate") == 2 then
        vim.cmd("MasonUpdate")
      end
    end

    if name == "molten-nvim" then
      if vim.fn.exists(":UpdateRemotePlugins") == 2 then
        vim.cmd("UpdateRemotePlugins")
      end
    end
  end,
})

-- Highlight yanked text (uses the `[ / `] marks set by the yank, so it
-- covers the exact region for yy, yiw, yi", y$, visual yanks, etc.)
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Absolute line numbers in insert mode, relative in normal mode.
local line_numbers_group = augroup("line_numbers")
vim.api.nvim_create_autocmd("InsertEnter", {
  group = line_numbers_group,
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = line_numbers_group,
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = true
    end
  end,
})

-- Lualine LSP highlight groups (re-applied on colorscheme change)
local function set_lsp_highlights()
  vim.api.nvim_set_hl(0, "CopperLspActive", { fg = "#a6e3a1" })
  vim.api.nvim_set_hl(0, "CopperLspBusy", { fg = "#fab387" })
  vim.api.nvim_set_hl(0, "CopperLspSpinner", { fg = "#89b4fa" })
  vim.api.nvim_set_hl(0, "CopperLspDim", { fg = "#6c7086" })
  vim.api.nvim_set_hl(0, "CopperLspIcon", { fg = "#a6e3a1" })
end
set_lsp_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup("lsp_highlights"),
  callback = set_lsp_highlights,
})

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

-- Persist folds across sessions
local view_group = augroup("save_view")
vim.api.nvim_create_autocmd("BufWinLeave", {
  group = view_group,
  pattern = "?*",
  callback = function()
    if vim.bo.buftype == "" then
      vim.cmd("silent! mkview")
    end
  end,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = view_group,
  pattern = "?*",
  callback = function()
    if vim.bo.buftype == "" then
      vim.cmd("silent! loadview")
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
      if vim.bo.buftype ~= "" then return end

      local spell_dir = vim.fn.stdpath("data") .. "/site/spell"
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
          local extensions = { "spl", "sug" }
          for _, ext in ipairs(extensions) do
            local name = lang .. ".utf-8." .. ext
            local url = base_url .. "/" .. name
            local pth = spell_dir .. "/" .. name
            local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
            local spin_idx = 0

            local notification = vim.notify(spinner[1] .. " " .. name, vim.log.levels.INFO, {
              title = "Spell",
              timeout = false,
            })

            -- Spinner timer (updates every 100ms while downloading)
            local timer = vim.uv.new_timer()
            timer:start(100, 100, vim.schedule_wrap(function()
              spin_idx = (spin_idx + 1) % #spinner
              notification = vim.notify(spinner[spin_idx + 1] .. " " .. name, vim.log.levels.INFO, {
                title = "Spell",
                replace = notification,
                timeout = false,
              })
            end))

            vim.system(
              { "curl", "--connect-timeout", "10", "--max-time", "60", "-#", "-fLo", pth, url },
              {
                stderr = function(_, data)
                  if not data then return end
                  local pct = data:match("(%d+%.%d)%%") or data:match("(%d+)%%")
                  if pct then
                    -- Real progress available — stop spinner, show percentage
                    timer:stop()
                    vim.schedule(function()
                      notification = vim.notify(name .. " — " .. pct .. "%", vim.log.levels.INFO, {
                        title = "Spell",
                        replace = notification,
                        timeout = false,
                      })
                    end)
                  end
                end,
              },
              function(result)
                timer:stop()
                timer:close()
                vim.schedule(function()
                  if result.code == 0 then
                    vim.notify("✓ " .. name, vim.log.levels.INFO, {
                      title = "Spell",
                      replace = notification,
                      timeout = 3000,
                    })
                    if ext == "spl" then
                      vim.opt.spelllang:append(lang)
                    end
                  else
                    vim.notify("✗ " .. name .. " (download failed)", vim.log.levels.ERROR, {
                      title = "Spell",
                      replace = notification,
                      timeout = 5000,
                    })
                  end
                end)
              end
            )
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

-- Banner splash: render the CopperVim banner when opening nvim without a file
-- (bare `nvim` or `nvim .`). Finds the first empty/directory buffer in a
-- non-floating window and replaces it with the banner.
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("splash"),
  once = true,
  callback = function()
    if vim.fn.argc() > 0 and vim.fn.isdirectory(vim.fn.argv(0)) == 0 then return end

    vim.schedule(function()
      local target_buf, target_win
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative == "" then
          local buf = vim.api.nvim_win_get_buf(win)
          local name = vim.api.nvim_buf_get_name(buf)
          local is_empty = name == ""
            and vim.bo[buf].buftype == ""
            and vim.bo[buf].filetype == ""
            and vim.api.nvim_buf_line_count(buf) <= 1
            and (vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or "") == ""
          local is_dir = name ~= "" and vim.fn.isdirectory(name) == 1
          if is_empty or is_dir then
            target_buf, target_win = buf, win
            break
          end
        end
      end
      if not target_buf then return end

      local art = {
        " ██████╗ ██████╗ ██████╗ ██████╗ ███████╗██████╗ ██╗   ██╗██╗███╗   ███╗",
        "██╔════╝██╔═══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗██║   ██║██║████╗ ████║",
        "██║     ██║   ██║██████╔╝██████╔╝█████╗  ██████╔╝██║   ██║██║██╔████╔██║",
        "██║     ██║   ██║██╔═══╝ ██╔═══╝ ██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║╚██╔╝██║",
        "╚██████╗╚██████╔╝██║     ██║     ███████╗██║  ██║ ╚████╔╝ ██║██║ ╚═╝ ██║",
        " ╚═════╝ ╚═════╝ ╚═╝     ╚═╝     ╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
      }

      local v = vim.version()
      local subtitle = string.format("hand-rolled  ·  nvim %d.%d", v.major, v.minor)

      -- Catppuccin Mocha gradient: peach -> maroon (6 interpolated steps)
      local gradient = { "#fab387", "#f7af8e", "#f4ab95", "#f1a89d", "#eea4a4", "#eba0ac" }
      for i, color in ipairs(gradient) do
        vim.api.nvim_set_hl(0, "CopperVimBanner" .. i, { fg = color, bold = true })
      end
      vim.api.nvim_set_hl(0, "CopperVimBannerSubtitle", { fg = "#7f849c", italic = true })

      local win_width = vim.api.nvim_win_get_width(target_win)
      local win_height = vim.api.nvim_win_get_height(target_win)
      local banner_height = #art + 2 -- art + blank + subtitle
      local top_pad = math.max(0, math.floor((win_height - banner_height) / 2))

      local function center(line)
        local pad = math.max(0, math.floor((win_width - vim.fn.strdisplaywidth(line)) / 2))
        return string.rep(" ", pad) .. line
      end

      local lines = {}
      for _ = 1, top_pad do table.insert(lines, "") end
      for _, line in ipairs(art) do table.insert(lines, center(line)) end
      table.insert(lines, "")
      table.insert(lines, center(subtitle))

      vim.bo[target_buf].modifiable = true
      vim.api.nvim_buf_set_lines(target_buf, 0, -1, false, lines)
      vim.bo[target_buf].modifiable = false
      vim.bo[target_buf].modified = false
      vim.bo[target_buf].buftype = "nofile"
      vim.bo[target_buf].bufhidden = "wipe"

      vim.wo[target_win].number = false
      vim.wo[target_win].relativenumber = false
      vim.wo[target_win].statuscolumn = ""
      vim.wo[target_win].cursorline = false
      vim.wo[target_win].list = false
      vim.b[target_buf].miniindentscope_disable = true
      vim.b[target_buf].indent_blankline_enabled = false

      -- Restore window options when banner buffer is replaced by a real file.
      vim.api.nvim_create_autocmd("BufWinLeave", {
        buffer = target_buf,
        once = true,
        callback = function()
          if vim.api.nvim_win_is_valid(target_win) then
            vim.wo[target_win].number = true
            vim.wo[target_win].relativenumber = true
            vim.wo[target_win].statuscolumn = vim.go.statuscolumn
            vim.wo[target_win].cursorline = true
          end
        end,
      })

      -- Apply gradient highlights via extmarks (one hl group per art row)
      local ns = vim.api.nvim_create_namespace("coppervim_banner")
      for i = 1, #art do
        local row = top_pad + i - 1
        vim.api.nvim_buf_set_extmark(target_buf, ns, row, 0, {
          end_row = row,
          end_col = #lines[row + 1],
          hl_group = "CopperVimBanner" .. i,
        })
      end
      local subtitle_row = top_pad + #art + 1
      vim.api.nvim_buf_set_extmark(target_buf, ns, subtitle_row, 0, {
        end_row = subtitle_row,
        end_col = #lines[subtitle_row + 1],
        hl_group = "CopperVimBannerSubtitle",
      })
    end)
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
