local lsp = require("lsp-zero")

lsp.preset("recommended")

-- TODO: Check if csharp will be added automatically
lsp.ensure_installed({
	'tsserver',
	'eslint',
	'sumneko_lua',
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

-- custom keybindings
local cmp_mappings = lsp.defaults.cmp_mappings({
	-- navigating code suggestions
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y>'] = cmp.mapping.confirm({select = true }),
	["<C-Space>"] = cmp.mapping.complete(),
})

-- This is suggested from thePrimageon, maybe test it out
--lsp.set_preferences({
--	sign_icons = {}
--})

lsp.setup_nvim_cmp({
	mapping = cmp_mappings
})

-- on_attach happens on every single buffer that has an lsp that's associated with it
-- that means, that all the following remaps only exist for the current buffer you are on
-- for example gd on a buffer that has an lsp will use lsp's [g]oto[d]efinition. On a buffer
-- that has no lsp associated gd will use vim instead to try to jump to definition.
lsp.on_attach(function(client, bufnr)
	local opts = {buffer = bufnr, remap = false}

	vim.keymap.set("n", "gd", function() vim.lsp.buf.definiton() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signatue_help() end, opts)
end)

lsp.setup()
