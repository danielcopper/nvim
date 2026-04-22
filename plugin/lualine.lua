vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lualine/lualine.nvim",
})

local icons = require("icons")

local opts = {
  options = {
    theme = "auto",
    globalstatus = true,
    refresh = { statusline = 300 },
    component_separators = { left = "", right = "" },
    section_separators = "",
    disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
  },
  sections = {
    lualine_a = {
      { "mode", icon = icons.ui.nvim },
    },
    lualine_b = {
      {
        function()
          if vim.fn.bufname() == "" then return "" end
          local devicons = require("nvim-web-devicons")
          local icon = devicons.get_icon_by_filetype(vim.bo.filetype, { default = true })
          return icon or ""
        end,
        separator = "",
        padding = { left = 2, right = 0 },
      },
      { "filename", path = 0, symbols = { modified = "", readonly = icons.ui.readonly, unnamed = icons.ui.unknown_file } },
    },
    lualine_c = {
      {
        "branch",
        icon = "",
        fmt = function(branch)
          if branch == "" then return "" end
          local git_path = vim.fn.getcwd() .. "/.git"
          local is_wt = vim.fn.isdirectory(git_path) == 0 and vim.fn.filereadable(git_path) == 1
          local icon = is_wt and icons.git.worktree or icons.git.branch
          return icon .. " " .. branch
        end,
      },
      { "diff", symbols = { added = icons.git.add, modified = icons.git.change, removed = icons.git.delete } },
    },
    lualine_x = {
      {
        "diagnostics",
        symbols = {
          error = icons.diagnostics.error,
          warn = icons.diagnostics.warn,
          info = icons.diagnostics.info,
          hint = icons.diagnostics.hint,
        },
      },
      {
        function()
          local all_clients = vim.lsp.get_clients()
          if next(all_clients) == nil then return icons.ui.lsp .. " --" end

          local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          local frame = spinner_frames[math.floor(vim.uv.now() / 80) % #spinner_frames + 1]
          local busy = require("lsp_state").busy

          local hl_active = "%#CopperLspActive#"
          local hl_busy = "%#CopperLspBusy#"
          local hl_spinner = "%#CopperLspSpinner#"
          local hl_dim = "%#CopperLspDim#"
          local hl_icon = "%#CopperLspIcon#"

          local buf_clients = {}
          for _, c in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
            buf_clients[c.id] = true
          end

          if vim.o.columns <= 80 then
            local any_busy = false
            for _, c in pairs(all_clients) do
              if busy[c.id] then any_busy = true break end
            end
            return hl_icon .. icons.ui.lsp .. (any_busy and (" " .. frame) or "")
          end

          local parts = {}
          for _, client in pairs(all_clients) do
            local hl = buf_clients[client.id] and hl_active or hl_dim
            if busy[client.id] then
              local name_hl = buf_clients[client.id] and hl_busy or hl_dim
              table.insert(parts, name_hl .. client.name .. " " .. hl_spinner .. frame)
            else
              table.insert(parts, hl .. client.name)
            end
          end

          return hl_icon .. icons.ui.lsp .. " " .. table.concat(parts, hl_dim .. ", ")
        end,
      },
      {
        function()
          return string.format("Ln %d, Col %d", vim.fn.line("."), vim.fn.col("."))
        end,
      },
      { "encoding", icons_enabled = false },
      {
        "fileformat",
        icons_enabled = false,
        fmt = function(str)
          if str == "unix" then return "" end
          local map = { dos = "CRLF", mac = "CR" }
          return map[str] or str
        end,
        cond = function()
          return vim.bo.fileformat ~= "unix"
        end,
      },
      { "filetype", icon = { align = "left" } },
    },
    lualine_y = {},
    lualine_z = {},
  },
  extensions = { "neo-tree", "trouble", "mason" },
}

-- Catppuccin palette color injection (previously in catppuccin.lua spec-merge).
local ok, palettes = pcall(require, "catppuccin.palettes")
if ok then
  local p = palettes.get_palette("mocha")

  for _, comp in ipairs(opts.sections.lualine_b) do
    if not comp.color then
      comp.color = { fg = p.text }
    end
  end

  local x = opts.sections.lualine_x
  -- x[1]=diagnostics, x[2]=LSP (own highlights), x[3]=Ln/Col, x[4]=encoding, x[5]=fileformat, x[6]=filetype
  if x[3] then x[3].color = { fg = p.overlay1 } end
  if x[4] then x[4].color = { fg = p.mauve } end
  if x[6] then x[6].color = { fg = p.blue } end
end

require("lualine").setup(opts)
