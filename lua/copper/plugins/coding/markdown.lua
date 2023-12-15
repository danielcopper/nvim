return {
  {
    "iamcco/markdown-preview.nvim",
    enabled = true,
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown",
    config = function ()
      vim.api.nvim_buf_set_keymap(0, "n", "<F5>", ":MarkdownPreviewToggle<cr>", { silent = true })
    end,
  },
}
