---@class Icons
---Requires Nerd Fonts to display correctly
local M = {}

---Diagnostic icons (errors, warnings, info, hints)
M.diagnostics = {
  error = "󰅚",
  hint = "󰌶",
  info = "󰋽",
  warn = "󰀪",
}

---LSP completion item kind icons
M.lsp = {
  kinds = {
    Array         = " ",
    Boolean       = "󰨙 ",
    Class         = " ",
    Codeium       = "󰘦 ",
    Collapsed     = " ",
    Color         = "󰏘 ",
    Constant      = "󰏿 ",
    Constructor   = " ",
    Control       = " ",
    Copilot       = " ",
    Enum          = " ",
    EnumMember    = " ",
    Event         = " ",
    Field         = " ",
    File          = "󰈙 ",
    Folder        = "󰉋 ",
    Function      = "󰊕 ",
    Interface     = " ",
    Key           = " ",
    Keyword       = "󰌋 ",
    Method        = "󰊕 ",
    Module        = " ",
    Namespace     = "󰦮 ",
    Null          = " ",
    Number        = "󰎠 ",
    Object        = " ",
    Operator      = " ",
    Package       = " ",
    Property      = "󰜢 ",
    Reference     = " ",
    Snippet       = "󱄽 ",
    String        = " ",
    Struct        = "󰆼 ",
    Supermaven    = " ",
    TabNine       = "󰏚 ",
    Text          = " ",
    TypeParameter = " ",
    Unit          = "󰑭 ",
    Value         = "󰎠 ",
    Variable      = "󰀫 ",
  }
}

---Git status icons
M.git = {
  add       = " ",
  branch    = " ",
  change    = " ",
  conflict  = " ",
  delete    = " ",
  ignored   = "󰈉 ",
  renamed   = "󰁕 ",
  staged    = " ",
  untracked = " ",
}

---Debug Adapter Protocol (DAP) icons
M.dap = {
  breakpoint = " ",
  breakpoint_condition = " ",
  breakpoint_rejected = " ",
  log_point = ".>",
  stopped = "󰁕 ",
}

---General UI icons
M.ui = {
  ai = "󰚩 ",
  arrow_down = " ",
  arrow_left = " ",
  arrow_right = " ",
  arrow_up = " ",
  buffer = "󰓩 ",
  check = " ",
  close = "󰅗 ",
  code = " ",
  delete = "󰆴 ",
  diff = "╱",
  eob = " ",
  file = "󰈙 ",
  find = " ",
  fold = "·",
  fold_minimal = " ",
  foldclose = "",
  folder = "󰉋 ",
  folder_empty = " ",
  folder_open = " ",
  foldopen = "",
  foldsep = "│",
  goto = "󰉚 ",
  loading = "󰝲 ",
  lock = " ",
  lsp = "󰣖 ",
  modified = "● ",
  next = " ",
  notifications = "󰂚 ",
  nvim = " ",
  package = "󰏖 ",
  prev = " ",
  prompt = "󰠗 ",
  quickfix = "󰒡 ",
  rename = "󰑕 ",
  search = " ",
  spinner = " ",
  surround = "󰗅 ",
  symlink_file = " ",
  symlink_folder = " ",
  terminal = " ",
  toggle = "󰙵 ",
  view = "󰈈 ",
  yank = "󰆏 ",
  Space = "󱁐 ",
  BS = "󰁮 ",
  Esc = "󱊷 ",
  CR = "󰌑 ",
  Tab = "󰌒 ",
  C = "󰘴 ",
  S = "󰘶 ",
  M = "󰘵 ",
}

return M
