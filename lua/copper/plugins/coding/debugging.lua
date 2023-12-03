return {
  -- textDocument/onTypeFormatting
  { "yioneko/nvim-type-fmt" },

  -- Virtual Text Variables
    {
        "theHamsta/nvim-dap-virtual-text",
        opts = { enabled = false },
        cmd = "DapVirtualTextToggle",
    },

    {
        "ofirgall/goto-breakpoints.nvim",
        keys = {
            { "]b", function() require("goto-breakpoints").next() end, desc = "Goto next breakpoint" },
            { "[b", function() require("goto-breakpoints").next() end, desc = "Goto prev breakpoint" },
        },
    },
}
