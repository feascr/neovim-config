return {
    { -- Autoformat
        "stevearc/conform.nvim",
        -- dependencies = { "mason.nvim" },
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({
                        async = true,
                        lsp_format = "fallback",
                    })
                end,
                mode = "",
                desc = "[F]ormat buffer",
            },
        },
        opts = {
            formatters = {
                ["markdown-toc"] = {
                    condition = function(_, ctx)
                        for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
                            if line:find("<!%-%- toc %-%->") then return true end
                        end
                    end,
                },
            },
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                local disable_filetypes = { c = true, cpp = true }
                local lsp_format_opt
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    lsp_format_opt = "never"
                else
                    lsp_format_opt = "fallback"
                end
                return {
                    timeout_ms = 500,
                    lsp_format = lsp_format_opt,
                }
            end,
            formatters_by_ft = {
                lua = { "stylua" },

                html = { "prettier" },
                markdown = {
                    "prettier",
                    "markdownlint",
                    "markdown-toc",
                },
                sh = { "shfmt" },
            },
        },
    },
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "stylua",
                "prettier",
                "shfmt",
                "markdownlint",
                "markdown-toc",
            },
        },
    },
}
