vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

-- nvim-treesitter main branch stores queries under runtime/ which vim.pack
-- doesn't auto-add to rtp. Prepend it so highlights/folds/indents are found.
local ts_root = vim.fn.stdpath("data") .. "/site/pack/core/opt/nvim-treesitter/runtime"
if vim.uv.fs_stat(ts_root) then
  vim.opt.rtp:prepend(ts_root)
end

-- Parsers to install via nvim-treesitter.
-- Excluded: lua, c, markdown, markdown_inline, query, vim, vimdoc — shipped
-- with Nvim 0.12 core and kept in sync with bundled queries.
local parsers = {
  "bash",
  "c_sharp",
  "css",
  "diff",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "luadoc",
  "python",
  "regex",
  "sql",
  "toml",
  "tsx",
  "typescript",
  "xml",
  "yaml",
}

local installed = require("nvim-treesitter").get_installed()
local to_install = vim.iter(parsers):filter(function(p)
  return not vim.list_contains(installed, p)
end):totable()

if #to_install > 0 then
  if vim.fn.executable("tree-sitter") == 0 then
    vim.notify(
      "tree-sitter CLI not found; parser install skipped (existing parsers still work)",
      vim.log.levels.WARN
    )
  else
    require("nvim-treesitter").install(to_install)
  end
end

-- Enable highlighting and indentation via FileType autocmd
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
  callback = function(ev)
    -- Skip large files
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
    if ok and stats and stats.size > max_filesize then return end

    local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
    if pcall(vim.treesitter.language.inspect, lang) then
      if pcall(vim.treesitter.start, ev.buf) then
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end
  end,
})

-- Incremental selection (native 0.12: an=expand, in=shrink, ]n/[n=siblings)
vim.keymap.set("n", "<C-space>", "van", { desc = "Select treesitter node" })
vim.keymap.set("x", "<C-space>", "an", { desc = "Expand to parent node" })
vim.keymap.set("x", "<bs>", "in", { desc = "Shrink to child node" })
