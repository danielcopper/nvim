return {
  "tpope/vim-fugitive",
  cmd = {
    "Git",
    "Gedit",
    "Gsplit",
    "Gdiffsplit",
    "Gvdiffsplit",
    "Gread",
    "Gwrite",
    "Ggrep",
    "Glgrep",
    "GMove",
    "GDelete",
    "GBrowse",
  },
  keys = {
    { "<leader>gs", vim.cmd.Git, desc = "Toggles Git" },
  },
}
