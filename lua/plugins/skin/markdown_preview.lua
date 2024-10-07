return {
    -- TODO: make it work. requires some obscure dependencies, debuggable through :mess
    -- {
    --     "iamcco/markdown-preview.nvim",
    --     cmd = {
    --         "MarkdownPreviewToggle",
    --         "MarkdownPreview",
    --         "MarkdownPreviewStop",
    --     },
    --     ft = { "markdown" },
    --     build = function()
    --         vim.fn["mkdp#util#install"]()
    --     end,
    --     config = function()
    --         vim.keymap.set(
    --             "n",
    --             "<leader>cp",
    --             "<cmd>MarkdownPreviewToggle<CR>",
    --             { desc = "Toogle markdown rendering" }
    --         )
    --     end,
    -- },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "echasnovski/mini.icons",
        },
        opts = {
            file_types = { "markdown", "norg", "rmd", "org" },
        },
        config = function(_, opts)
            require("render-markdown").setup(opts)

            local render_markdown = function()
                local enabled = require("render-markdown.state").enabled
                local m = require("render-markdown")
                if not enabled then
                    m.enable()
                else
                    m.disable()
                end
            end
            vim.keymap.set("n", "<leader>tm", render_markdown, { desc = "Toogle markdown rendering" })
        end,
    },
}
