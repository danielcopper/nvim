return {
  -- More detailed lsp diagnostics info
  {
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = { "BufEnter" },
    config = function()
      vim.diagnostic.config({
        virtual_text = false,
      })

      -- Disable the plugin in specified filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "lazy",
        callback = function()
          local previous = not require("lsp_lines").toggle()
          if not previous then
            require("lsp_lines").toggle()
          end
        end,
      })

      require("lsp_lines").setup()
    end,
  },
}
