-- VSCode-specific plugin configurations
-- These override default plugin settings when running in VSCode

if not vim.g.vscode then
  return {}
end

return {
  -- Treesitter: keep for text objects, disable highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = { enable = false }, -- VSCode handles syntax highlighting
      indent = { enable = false }, -- VSCode handles indentation
    },
  },

  -- Mark additional plugins for VSCode if needed
  -- Example: { "author/plugin", vscode = true },
}
