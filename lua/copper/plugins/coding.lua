local set = vim.keymap.set
local icons = require("copper.plugins.extras.icons")

-- Plugins related to coding workflow like how brackets work or autocompletion and snippets
return {
    -- Code snippets and completions
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "L3MON4D3/LuaSnip",             -- the actual snippet engine
            "hrsh7th/cmp-nvim-lsp",         -- completion source for lsp related stuff
            "hrsh7th/cmp-buffer",           -- source for words in buffer
            "hrsh7th/cmp-path",             -- source for path completion
            "saadparwaiz1/cmp_luasnip",     -- for autocompletion
            "rafamadriz/friendly-snippets", -- collection of useful snippets for different languages
            "onsails/lspkind-nvim",         -- change the appearance of the popup
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            -- keymaps for luasnip
            set({ "i", "s" }, "<C-f>", function()
                luasnip.jump(1)
            end, { silent = true })
            set({ "i", "s" }, "<C-b>", function()
                luasnip.jump(-1)
            end, { silent = true })

            -- load vscode style snippets from installed plugins (e.g. friendly-snippets)
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                keyword_length = 2,
                completion = {
                    completeopt = "menu,menuone,preview,noselect",
                },

                snippet = {
                    -- configure how nvim-cmp interacts with the snippet engine
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                window = {
                    completion = {
                        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                        col_offset = -3,
                        side_padding = 0,
                    },
                    -- completion = cmp.config.window.bordered(),
                    -- documentation = cmp.config.window.bordered(),
                },

                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    -- TODO: Maybe extend this to also use own icons like shown here: https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
                    -- and add min_width
                    -- adds vscode like indicators in the suggestion list
                    format = function(entry, vim_item)
                        local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
                        local strings = vim.split(kind.kind, "%s", { trimempty = true })
                        kind.kind = " " .. (strings[1] or "") .. " "
                        kind.menu = "    (" .. (strings[2] or "") .. ")"

                        return kind
                    end,
                },

                mapping = cmp.mapping.preset.insert({
                    ["<C-j>"] = cmp.mapping.select_next_item(),        -- jump to next suggestion
                    ["<C-k>"] = cmp.mapping.select_prev_item(),        -- jump to previous suggestion
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),            -- scroll through the hover documentation down
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),           -- scroll through the hover documentation up
                    ["<C-Space>"] = cmp.mapping.complete(),            -- show completion suggestions
                    ["<C-c>"] = cmp.mapping.abort(),                   -- close completion suggestions
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- apply suggestion (autoselect top suggestion)
                }),

                -- the sources for autocompletion, the order is represented in the suggestions
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },                      -- LSP related snippets
                    { name = "luasnip" },                       -- snippets
                    { name = "buffer",  max_view_entries = 10 }, -- NOTE: if this doesn't work try max_item_count instead
                    { name = "path" },                          -- file system paths
                }),

                -- disable the completion in comment sections
                enabled = function()
                    -- disable completion in comments
                    local context = require("cmp.config.context")
                    -- keep command mode completion enabled when cursor is in a comment
                    if vim.api.nvim_get_mode().mode == "c" then
                        return true
                    else
                        return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
                    end
                end,

                performance = {
                    max_view_entries = 20,
                },
            })
        end,
    },

    -- autoinsert matching pairs
    {
        "altermo/ultimate-autopair.nvim",
        event = { "InsertEnter", "CmdlineEnter" },
        config = function()
            require("ultimate-autopair").setup({})
        end,
    },

    -- Surround options
    {
        "echasnovski/mini.surround",
        keys = function(_, keys)
            -- Populate the keys based on the user's options
            local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
            local opts = require("lazy.core.plugin").values(plugin, "opts", false)
            local mappings = {
                { opts.mappings.add,            desc = "Add surrounding",                     mode = { "n", "v" } },
                { opts.mappings.delete,         desc = "Delete surrounding" },
                { opts.mappings.find,           desc = "Find right surrounding" },
                { opts.mappings.find_left,      desc = "Find left surrounding" },
                { opts.mappings.highlight,      desc = "Highlight surrounding" },
                { opts.mappings.replace,        desc = "Replace surrounding" },
                { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
            }
            mappings = vim.tbl_filter(function(m)
                return m[1] and #m[1] > 0
            end, mappings)
            return vim.list_extend(mappings, keys)
        end,
        opts = {
            mappings = {
                add = "gza",            -- Add surrounding in Normal and Visual modes
                delete = "gzd",         -- Delete surrounding
                find = "gzf",           -- Find surrounding (to the right)
                find_left = "gzF",      -- Find surrounding (to the left)
                highlight = "gzh",      -- Highlight surrounding
                replace = "gzr",        -- Replace surrounding
                update_n_lines = "gzn", -- Update `n_lines`
            },
        },
    },

    -- NOTE: Search for plugins that enable xml comments and such
    -- Code Comments
    {
        "numToStr/Comment.nvim",
        -- TODO: Find a better way to lazy load
        lazy = false,
        config = true,
    },
    {
        -- TODO: Find out what other plugin? causes the other highlights like TODO
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = "BufReadPost",
        opts = {
            signs = true,      -- show icons in the signs column
            sign_priority = 8, -- sign priority
            -- keywords recognized as todo comments
            keywords = {
                FIX = {
                    icon = icons.ui.Bug, -- icon used for the sign, and in search results
                    color = "error", -- can be a hex color, or a named color (see below)
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
                    -- signs = false, -- configure signs for some keywords individually
                },
                TODO = { icon = icons.ui.CheckAlt2, color = "info", alt = { "todo", "ToDo", "Todo", "toDo" } },
                HACK = { icon = icons.ui.Fire, color = "warning", alt = { "hack", "Hack" } },
                WARN = { icon = icons.diagnostics.Warning, color = "warning", alt = { "WARNING", "XXX", "warn", "warning" } },
                -- TODO:Find this icon that doesn't work on linux
                -- PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                PERF = { icon = icons.ui.History, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                -- NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                NOTE = { icon = icons.ui.Electric, color = "hint", alt = { "INFO" } },
                TEST = { icon = icons.ui.Time, color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
            },
            gui_style = {
                fg = "NONE",       -- The gui style to use for the fg highlight group.
                bg = "BOLD",       -- The gui style to use for the bg highlight group.
            },
            merge_keywords = true, -- when true, custom keywords will be merged with the defaults
            -- highlighting of the line containing the todo comment
            -- * before: highlights before the keyword (typically comment characters)
            -- * keyword: highlights of the keyword
            -- * after: highlights after the keyword (todo text)
            highlight = {
                multiline = true,                -- enable multine todo comments
                multiline_pattern = "^.",        -- lua pattern to match the next multiline from the start of the matched keyword
                multiline_context = 10,          -- extra lines that will be re-evaluated when changing a line
                before = "",                     -- "fg" or "bg" or empty
                keyword = "wide",                -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
                after = "fg",                    -- "fg" or "bg" or empty
                pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
                comments_only = true,            -- uses treesitter to match keywords in comments only
                max_line_len = 400,              -- ignore lines longer than this
                exclude = {},                    -- list of file types to exclude highlighting
            },
            -- list of named colors where we try to extract the guifg from the
            -- list of highlight groups or use the hex color if hl not found as a fallback
            colors = {
                error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
                warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
                info = { "DiagnosticInfo", "#2563EB" },
                hint = { "DiagnosticHint", "#10B981" },
                default = { "Identifier", "#7C3AED" },
                test = { "Identifier", "#FF00FF" },
            },
            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
                -- regex that will be used to match keywords.
                -- don't replace the (KEYWORDS) placeholder
                pattern = [[\b(KEYWORDS):]], -- ripgrep regex
                -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
            },
        },
        keys = {
            vim.keymap.set("n", "]t", function()
                require("todo-comments").jump_next()
            end, { desc = "Next todo comment" }),
            vim.keymap.set("n", "[t", function()
                require("todo-comments").jump_prev()
            end, { desc = "Previous todo comment" }),
            vim.keymap.set('n', '<leader>xt', '<Cmd>TodoTrouble<CR>', { desc = 'Open TodoTrouble' }),
            vim.keymap.set('n', '<leader>xT', '<Cmd>TodoTrouble<CR>', { desc = 'Todo/Fix/Fixme (Trouble)' }),
        },
    },

    -- Tabout of parenthesis
    {
        "abecodes/tabout.nvim",
        event = "BufEnter",
        config = function()
            require("tabout").setup({
                tabkey = "<Tab>",             -- key to trigger tabout, set to an empty string to disable
                backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
                act_as_tab = true,            -- shift content if tab out is not possible
                act_as_shift_tab = false,     -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
                default_tab = "<C-t>",        -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
                default_shift_tab = "<C-d>",  -- reverse shift default action,
                enable_backwards = true,      -- well ...
                -- NOTE: so far this didn't cause issues
                completion = true,            -- if the tabkey is used in a completion pum
                tabouts = {
                    { open = "'", close = "'" },
                    { open = '"', close = '"' },
                    { open = "`", close = "`" },
                    { open = "(", close = ")" },
                    { open = "[", close = "]" },
                    { open = "{", close = "}" },
                    { open = "<", close = ">" },
                    { open = "'", close = "'" },
                },
                ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
                exclude = {}, -- tabout will ignore these filetypes
            })
        end,
    },

    -- Terminal inside neovim when tmux is not available
    {
        "akinsho/toggleterm.nvim",
        lazy = false,
        opts = {
            size = 30,
            -- NOTE: Change when on windows
            shell = "bash",
            insert_mappings = true,
        },
        config = function(_, opts)
            -- NOTE: Windows related
            -- local powershell_options = {
            --     shell = vim.fn.executable 'pwsh' == 1 and 'pwsh' or 'powershell',
            --     shellcmdflag =
            --     '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;',
            --     shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait',
            --     shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode',
            --     shellquote = '',
            --     shellxquote = '',
            -- }
            --
            -- for option, value in pairs(powershell_options) do
            --     vim.opt[option] = value
            -- end

            require("toggleterm").setup(opts)

            local Terminal = require("toggleterm.terminal").Terminal
            local lazygit = Terminal:new({
                cmd = "lazygit",
                hidden = true,
                start_in_insert = false,
                dir = "git_dir",
                direction = "float",
                float_opts = {
                    border = { "╒", "═", "╕", "│", "╛", "═", "╘", "│" },
                    width = 200,
                    height = 40,
                },
            })

            function Lazygit_toggle()
                lazygit:toggle()
            end
        end,
        keys = {
            -- this maps the leader Esc key so that the terminal actually looses focus and the toggle works inside the terminal
            vim.keymap.set("t", "<leader><esc>", [[<C-\><C-n>]]),

            -- window movement wenn in terminal
            vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]]),
            vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]]),
            vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]]),
            vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]]),

            -- opening different terminals
            vim.keymap.set("n", "<leader>t", ":ToggleTerm<CR>"),
            vim.keymap.set("n", "<leader>t1", ":1ToggleTerm<CR>"),
            vim.keymap.set("n", "<leader>t2", ":2ToggleTerm<CR>"),
            vim.keymap.set("n", "<leader>t2", ":2ToggleTerm<CR>"),
            vim.keymap.set("n", "<leader>ta", ":ToggleTermToggleAll<CR>"),
            vim.keymap.set("n", "<leader>lg", ":lua Lazygit_toggle()<CR>"),
        },
    },

    -- Markdown preview in browser
    {
        "iamcco/markdown-preview.nvim",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        ft = "markdown",
    },
}
