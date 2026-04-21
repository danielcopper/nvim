-- Custom vim.ui.input implementation: borderless float at cursor with
-- the CopperVim scheme (crust body, peach title). Replaces the native
-- 0.12 implementation which hardcodes a rounded border and doesn't
-- pick up our FloatTitle/FloatBorder highlights predictably.

vim.ui.input = function(opts, on_confirm)
  opts = opts or {}
  local default = opts.default or ""
  local prompt = opts.prompt or "Input"

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { default })

  local width = math.max(40, #prompt + 4, #default + 10)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "cursor",
    row = 1,
    col = 0,
    width = width,
    height = 1,
    style = "minimal",
    -- "solid" renders space chars as border; combined with FloatBorder
    -- bg=crust it looks borderless but leaves room for the title row.
    border = "solid",
    title = " " .. prompt .. " ",
    title_pos = "center",
  })

  vim.wo[win].winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,FloatTitle:FloatTitle"
  vim.api.nvim_win_set_cursor(win, { 1, #default })
  vim.cmd("startinsert!")

  local closed = false
  local function close(confirmed)
    if closed then return end
    closed = true
    local text = nil
    if confirmed and vim.api.nvim_buf_is_valid(buf) then
      text = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
    end
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    vim.schedule(function() on_confirm(text) end)
  end

  vim.keymap.set({ "n", "i" }, "<CR>", function() close(true) end, { buffer = buf })
  vim.keymap.set({ "n", "i" }, "<Esc>", function() close(false) end, { buffer = buf })
  vim.keymap.set("i", "<C-c>", function() close(false) end, { buffer = buf })

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    once = true,
    callback = function() close(false) end,
  })
end
