return {
    -- TODO: Sometimes automatically folds in neo-tree, Fix or keep disabled
    -- {
    --     "kevinhwang91/nvim-ufo",
    --     enabled = true,
    --     event = "BufRead",
    --     dependencies = { "kevinhwang91/promise-async" },
    --     config = function()
    --         -- Fold options
    --         -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    --         vim.o.foldcolumn = "0" -- '0' is not bad -> controls the width of the extra column for fold icons
    --         vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
    --         vim.o.foldlevelstart = 99
    --         vim.o.foldenable = true
    --
    --         require("ufo").setup()
    --     end,
    -- },
    {
        "kevinhwang91/nvim-ufo",
        enabled = true,
        dependencies = { "kevinhwang91/promise-async" },
        event = "BufRead",
        keys = {
            {
                "zP",
                function()
                    local winid = require("ufo").peekFoldedLinesUnderCursor()
                    if not winid then
                        vim.lsp.buf.hover()
                    end
                end,
            },
        },
        config = function()
            vim.o.foldcolumn = "0"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            -- To show number of folded lines
            local handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = ("  ↙ %d "):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, { suffix, "MoreMsg" })
                return newVirtText
            end

            require("ufo").setup({
                fold_virt_text_handler = handler,
            })

            -- Disable UFO on certain filetypes
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "neo-tree" },
                callback = function()
                    require("ufo").detach()
                    vim.opt_local.foldenable = false
                end,
            })
        end,
    },
}
