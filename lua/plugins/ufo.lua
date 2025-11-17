-- nvim-ufo: Better folding with LSP and Treesitter support

return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
  },
  event = { "BufReadPost", "BufNewFile" },

  opts = {
    provider_selector = function(bufnr, filetype, buftype)
      return { "treesitter", "indent" }
    end,
  },

  config = function(_, opts)
    -- Using ufo provider need remap `zR` and `zM`
    vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })

    require("ufo").setup(opts)
  end,
}
