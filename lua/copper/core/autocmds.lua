local function augroup(name)
  return vim.api.nvim_create_augroup("copper_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  command = "checktime",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- remember last cursor location of files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_location"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_and_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("toggle_spell_checking"),
  desc = "Turn on spell checking on files where it makes sense.",
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- close some stuff with q
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_buffers"),
  -- this is the stuff to close
  pattern = "fugitive",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "q", "<Cmd>q<CR>", { noremap = true, silent = true })
  end
})

-- NOTE: Test this it should open stuff that can't be opened in nvim with an external app
vim.api.nvim_create_autocmd("BufRead", {
  desc = "Open non-Vim-readable files in system default applications.",
  group = augroup("open_externally"),
  pattern = "*.png, *.jpg, *.gif, *.pdf, *.xls*, *.ppt, *.doc*, *.rtf",
  command = "sil exe '!open ' . shellescape(expand('%:p')) | bd | let &ft=&ft",
})
