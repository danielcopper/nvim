-- Centralized icon definitions
-- Single source of truth for ALL icons used across the config

local M = {}

-- LSP completion item kinds (used in nvim-cmp)
M.kinds = {
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "",
}

-- Diagnostic icons (used in LSP diagnostics, signs, etc.)
M.diagnostics = {
  Error = "󰅚",
  Warn = "󰀪",
  Hint = "󰌶",
  Info = "",
}

-- Git icons (used in gitsigns, diffview, etc.)
M.git = {
  Add = "",
  Modify = "",
  Delete = "",
  Rename = "",
  Untracked = "",
  Ignored = "",
  Unstaged = "󰄱",
  Staged = "",
  Conflict = "",
}

-- DAP (Debug Adapter Protocol) icons
M.dap = {
  Breakpoint = "",
  BreakpointCondition = "",
  BreakpointRejected = "",
  LogPoint = ".>",
  Stopped = "󰁕",
}

-- UI icons (general purpose)
M.ui = {
  Folder = "󰉋",
  FolderOpen = "",
  File = "󰈙",
  Files = "",
  Close = "󰅖",
  Search = "",
  Settings = "",
  History = "",
  Clock = "",
  Check = "",
  Fire = "",
  Project = "",
  Dashboard = "",
  Bookmarks = "",
  Bug = "",
  Code = "",
  Telescope = "",
  Gear = "",
  Package = "",
  List = "",
  SignIn = "",
  SignOut = "",
  Tab = "󰓩",
  Lock = "",
  Circle = "",
}

-- File type icons (optional, can be extended)
M.filetypes = {
  lua = "",
  python = "",
  javascript = "",
  typescript = "",
  rust = "",
  go = "",
  c = "",
  cpp = "",
  java = "",
  html = "",
  css = "",
  json = "",
  yaml = "",
  markdown = "",
  vim = "",
}

return M
