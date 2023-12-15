return {
  "Zeioth/compiler.nvim",
  cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
  dependencies = { "stevearc/overseer.nvim" },
  keys = {
    -- Open compiler
    vim.api.nvim_set_keymap('n', '<leader>co', "<cmd>CompilerOpen<cr>", { noremap = true, silent = true }),

    -- Redo last selected option
    vim.api.nvim_set_keymap('n', '<leader>cr',
      "<cmd>CompilerStop<cr>" -- (Optional, to dispose all tasks before redo)
      .. "<cmd>CompilerRedo<cr>",
      { noremap = true, silent = true }),

    -- Toggle compiler results
    vim.api.nvim_set_keymap('n', '<leader>ctr', "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true }),
  },
  opts = {},
}
