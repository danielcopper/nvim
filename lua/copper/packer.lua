-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- telescope helps navigating (open project files, search project files etc. -> check telescope.lua for more)
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- Color theme, more configuration is also found in color.lua
    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })

    -- treesitter is for parsing the documents (highlighting etc.), check treesitter.lua for more
    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

    -- Doesn't seem to work at the moment -> do some research
    -- use('nvim-treesitter/playground')

    -- Quick Navigation for recently used files
    -- Allows to add files to a quick switch list
    -- Check harpoon.lua
    -- use('theprimeagen/harpoon')

    -- visualize undo history of vim
    -- as always check the undotree.lua file
    use('mbbill/undotree')
    use('tpope/vim-fugitive')

    -- lsp eliminate boiler and more
    -- check lsp.lua
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            -- Snippet Collection (Optional)
            {'rafamadriz/friendly-snippets'},
        }
    }

    -- icons
    use('nvim-tree/nvim-web-devicons')

    -- file explorer
    use {
        'nvim-tree/nvim-tree.lua',
        wants = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        -- tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }

    -- tabs for open document
    use {'romgrk/barbar.nvim', wants = 'nvim-web-devicons'}

    -- better bottom status line
    use {
        'nvim-lualine/lualine.nvim',
        wants = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- auto close brackets
    use('cohama/lexima.vim')

    -- Tab Out
    use {
        'abecodes/tabout.nvim',
        wants = {'nvim-treesitter'}, -- or require if not used so far
        after = {'nvim-cmp'} -- if a completion plugin is using tabs load it before
    }

    -- terminal integration
    use('voldikss/vim-floaterm')

    -- Debugging
    use 'mfussenegger/nvim-dap'
    -- Generate the documentation for nvim-dap using :helptags ALL
    use { "rcarriga/nvim-dap-ui", wants = {"mfussenegger/nvim-dap"} }

    -- maybe activate later
    --use 'nvim-telescope/telescope-dap.nvim'

    -- gitsigns
    use {
        'lewis6991/gitsigns.nvim',
        tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
    }

    -- make it easier to see indent lines
    use "lukas-reineke/indent-blankline.nvim"

    -- easy comment wrapping
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

end)
