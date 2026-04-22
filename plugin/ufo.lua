vim.pack.add({
  "https://github.com/kevinhwang91/promise-async",
  "https://github.com/kevinhwang91/nvim-ufo",
})

local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local foldedLines = endLnum - lnum
  local suffix = (" ··· ↙ %d "):format(foldedLines)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "UfoFoldedEllipsis" })
  return newVirtText
end

require("ufo").setup({
  provider_selector = function(bufnr, filetype, buftype)
    return { "treesitter", "indent" }
  end,
  fold_virt_text_handler = handler,
  preview = {
    win_config = {
      winhighlight = "Normal:Normal",
      winblend = 0,
    },
  },
})

-- Must run AFTER setup() and re-apply on ColorScheme since ufo resets these
local function set_ufo_highlights()
  vim.cmd("hi! UfoFoldedEllipsis guifg=#89b4fa guibg=NONE")
  vim.cmd("hi! UfoFoldedBg guibg=NONE")
end
set_ufo_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_ufo_highlights })

vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })

vim.keymap.set("n", "K", function()
  if not require("ufo").peekFoldedLinesUnderCursor() then
    vim.lsp.buf.hover()
  end
end, { desc = "Peek fold or LSP hover" })
