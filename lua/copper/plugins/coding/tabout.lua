return {
  {
    "abecodes/tabout.nvim",
    event = "bufenter",
    config = function()
      require("tabout").setup({
        tabkey = "<tab>",             -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = "<s-tab>", -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true,            -- shift content if tab out is not possible
        act_as_shift_tab = true,      -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <s-tab>)
        default_tab = "<c-t>",        -- shift default action (only at the beginning of a line, otherwise <tab> is used)
        default_shift_tab = "<c-d>",  -- reverse shift default action,
        enable_backwards = true,      -- well ...
        completion = true,            -- if the tabkey is used in a completion pum
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          { open = "{", close = "}" },
          { open = "<", close = ">" },
          { open = "#", close = ";" },
        },
        ignore_beginning = true, -- if the cursor is at the beginning of a filled element it will rather tab out than shift the content
        exclude = {},            -- tabout will ignore these filetypes
      })
    end,
  },
}
