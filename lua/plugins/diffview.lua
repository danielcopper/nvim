-- Diffview: Side-by-side diff viewer and file history

return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff view" },
    { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
    { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current)" },
    { "<leader>gF", "<cmd>DiffviewFileHistory<cr>", desc = "File history (repo)" },
  },
  opts = {
    enhanced_diff_hl = true,
    use_icons = true,
    view = {
      default = { layout = "diff2_horizontal" },
      merge_tool = { layout = "diff3_horizontal" },
    },
    file_panel = {
      listing_style = "tree",
      tree_options = {
        flatten_dirs = true,
        folder_statuses = "only_folded",
      },
      win_config = {
        position = "left",
        width = 35,
      },
    },
  },
}
