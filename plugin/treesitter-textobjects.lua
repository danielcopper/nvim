vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
})

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
