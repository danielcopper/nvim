-- Auto-pairs: Automatically insert matching brackets, quotes, etc.

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true, -- Enable treesitter
    ts_config = {
      lua = { "string" }, -- Don't add pairs in lua string treesitter nodes
      javascript = { "template_string" },
      java = false, -- Don't check treesitter on java
    },
    disable_filetype = { "TelescopePrompt", "vim" },
    fast_wrap = {
      map = "<M-e>", -- Alt+e to fast wrap
      chars = { "{", "[", "(", '"', "'" },
      pattern = [=[[%'%"%>%]%)%}%,]]=],
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "Search",
      highlight_grey = "Comment",
    },
  },
}
