-- Gitsigns: Git integration for buffers

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    current_line_blame = true, -- Show git blame inline
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      delay = 500,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- Navigation
      map("n", "]h", gs.next_hunk, "Next git hunk")
      map("n", "[h", gs.prev_hunk, "Previous git hunk")

      -- Actions
      map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
      map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage hunk")
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset hunk")
      map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
      map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
      map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
      map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, "Blame line")
      map("n", "<leader>hd", gs.diffthis, "Diff this")
      map("n", "<leader>hD", function()
        gs.diffthis("~")
      end, "Diff this ~")

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns select hunk")
    end,
  },
}
