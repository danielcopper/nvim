-- Treesitter: syntax highlighting, indentation, textobjects
-- Requires tree-sitter CLI (brew install tree-sitter)

local parsers = {
  "bash",
  "c",
  "c_sharp",
  "css",
  "diff",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "sql",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      -- Install missing parsers
      local installed = require("nvim-treesitter").get_installed()
      local to_install = vim.iter(parsers):filter(function(p)
        return not vim.list_contains(installed, p)
      end):totable()
      if #to_install > 0 then
        require("nvim-treesitter").install(to_install)
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
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      -- Select textobjects
      local select_maps = {
        ["af"] = { "@function.outer", "Select around function" },
        ["if"] = { "@function.inner", "Select inside function" },
        ["ac"] = { "@class.outer", "Select around class" },
        ["ic"] = { "@class.inner", "Select inside class" },
        ["aa"] = { "@parameter.outer", "Select around argument" },
        ["ia"] = { "@parameter.inner", "Select inside argument" },
        ["ai"] = { "@conditional.outer", "Select around conditional" },
        ["ii"] = { "@conditional.inner", "Select inside conditional" },
        ["al"] = { "@loop.outer", "Select around loop" },
        ["il"] = { "@loop.inner", "Select inside loop" },
        ["ab"] = { "@block.outer", "Select around block" },
        ["ib"] = { "@block.inner", "Select inside block" },
      }
      for key, val in pairs(select_maps) do
        vim.keymap.set({ "x", "o" }, key, function()
          select.select_textobject(val[1], "textobjects")
        end, { desc = val[2] })
      end

      -- Move between textobjects
      local move_maps = {
        { "]f", "goto_next_start", "@function.outer", "Next function start" },
        { "]c", "goto_next_start", "@class.outer", "Next class start" },
        { "]a", "goto_next_start", "@parameter.inner", "Next argument" },
        { "]F", "goto_next_end", "@function.outer", "Next function end" },
        { "]C", "goto_next_end", "@class.outer", "Next class end" },
        { "[f", "goto_previous_start", "@function.outer", "Previous function start" },
        { "[c", "goto_previous_start", "@class.outer", "Previous class start" },
        { "[a", "goto_previous_start", "@parameter.inner", "Previous argument" },
        { "[F", "goto_previous_end", "@function.outer", "Previous function end" },
        { "[C", "goto_previous_end", "@class.outer", "Previous class end" },
      }
      for _, m in ipairs(move_maps) do
        vim.keymap.set({ "n", "x", "o" }, m[1], function()
          move[m[2]](m[3], "textobjects")
        end, { desc = m[4] })
      end
    end,
  },
}
