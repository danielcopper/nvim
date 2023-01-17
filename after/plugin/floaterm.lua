vim.keymap.set("n", "<leader>t", ":FloatermToggle<CR>")
vim.keymap.set("n", "<leader>nt", ":FloatermNew<CR>")
vim.keymap.set("n", "<F8>", ":FloatermPrev<CR>")
vim.keymap.set("n", "<F9>", ":FloatermNext<CR>")

vim.g.floaterm_shell = "pwsh"

-- this maps the Esc key so that the terminal actually looses focus and the toggle works inside the terminal
vim.cmd([[ tmap <Esc> <c-\><c-n> ]])

-- just leaving this here as an example on how it should look
--vim.cmd([[
--nnoremap  <silent> <F7> :FloatermNew<CR>
--]])
