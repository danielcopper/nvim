-- UI preferences (colorscheme-independent).
-- Central source of truth for border style across telescope, noice,
-- mason, which-key, blink.cmp, LSP floats, etc.
local M = {}

M.borders = "none" -- "none" | "rounded" | "single" | "double"

M.borderchars = M.borders == "none"
    and { " ", " ", " ", " ", " ", " ", " ", " " }
    or  { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

return M
