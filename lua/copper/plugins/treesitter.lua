return {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    config = function()
        -- TODO: hopefully this will be obsolete at some point
        require 'nvim-treesitter.install'.prefer_git = false
        require 'nvim-treesitter.install'.compilers = { 'gcc' }
        require 'nvim-treesitter.configs'.setup {
            -- A list of parser names, or "all"
            -- ensure_installed = { "c", "cpp", "vim", "help", "typescript", "c_sharp", "lua", "cmake", "html" },
            ensure_installed = { "c", "cpp", "vim", "typescript", "c_sharp", "lua", "cmake", "html" },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = true,

            -- List of parsers to ignore installing (for "all")
            --ignore_install = { "javascript" },

            ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
            -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

            highlight = {
                -- `false` will disable the whole extension
                enable = true,

                -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
                -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
                -- the name of the parser)
                -- list of language that will be disabled
                --disable = { "c", "rust" },
                -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
                --disable = function(lang, buf)
                --    local max_filesize = 100 * 1024 -- 100 KB
                --    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                --    if ok and stats and stats.size > max_filesize then
                --        return true
                --    end
                --end,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            },

            -- TODO: This needs improvements:
            -- - command to unfold all -> official command not working
            -- - fold with motion
            -- This autocommand helps to enable codefolding
            -- zc folds the block under curser, zo unfolds, zm folds the complete file
            -- unsure about the difference from zc to za
            vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd', 'BufNew', 'BufNewFile', 'BufWinEnter' }, {
                group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
                callback = function()
                    vim.opt.foldmethod = 'expr'
                    vim.opt.foldexpr   = 'nvim_treesitter#foldexpr()'
                    vim.opt.foldenable = false -- disable folding when opening a buffer
                end
            })
        }
    end
}
