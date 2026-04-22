vim.pack.add({ "https://github.com/3rd/image.nvim" })

-- image.nvim: image display via terminal graphics protocol.
-- Only set up if terminal + ImageMagick are available.
local supported_term = vim.env.TERM_PROGRAM == "WezTerm"
  or vim.env.TERM == "xterm-kitty"
  or vim.env.TERM_PROGRAM == "ghostty"
local has_magick = vim.fn.executable("magick") == 1 or vim.fn.executable("convert") == 1

if not (supported_term and has_magick) then return end

require("image").setup({
  backend = "kitty",
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
    },
  },
  max_width = 100,
  max_height = 12,
  max_width_window_percentage = nil,
  max_height_window_percentage = 50,
  window_overlap_clear_enabled = false,
  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
})
