-- LSP Lens: Show references/implementations inline (DISABLED)

return {
  "VidocqH/lsp-lens.nvim",
  enabled = false, -- Disabled as requested
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    enable = true,
    include_declaration = false,
    sections = {
      definition = false,
      references = true,
      implements = true,
      git_authors = false,
    },
    ignore_filetype = {
      "prisma",
    },
  },
}
