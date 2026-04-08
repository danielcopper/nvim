return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, "tsconfig.json")
    if not root then
      root = vim.fs.root(bufnr, ".git")
    end
    if root then on_dir(root) end
  end,
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayFunctionParameterTypeHints = true,
      },
    },
  },
}
