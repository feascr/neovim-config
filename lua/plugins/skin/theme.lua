return {
    {
        "folke/tokyonight.nvim",
        priority = 1000, -- Make sure to load this before all the other start plugins.
        opts = {
            transparent = true,
            styles = {
                sidebars = "normal",
                floats = "transparent",
            },
        },
        init = function()
            vim.cmd.colorscheme("tokyonight-night")

            vim.cmd.hi("Comment gui=none")
        end,
    },
}

-- return {
--     {
--         "catppuccin/nvim",
--         name = "catppuccin",
--         priority = 1000,
--         opts = {
--             -- transparent_background = true,
--             -- term_colots = true,
--             -- custom_highlights = function(colors)
--             --     local u = require("catppuccin.utils.colors")
--             --     return {
--             --         CursorLineNr = { bg = u.blend(colors.overlay0, colors.base, 0.75), style = { "bold" } },
--             --         CursorLine = { bg = u.blend(colors.overlay0, colors.base, 0.45) },
--             --         LspReferenceText = { bg = colors.surface2 },
--             --         LspReferenceWrite = { bg = colors.surface2 },
--             --         LspReferenceRead = { bg = colors.surface2 },
--             --     }
--             -- end,
--         },
--         init = function()
--             vim.cmd.colorscheme("catppuccin")
--             -- vim.cmd.colorscheme("catppuccin-mocha")
--             -- vim.cmd.hi("Comment gui=none")
--         end,
--         config = function()
--             require("catppuccin").setup({
--
--                 transparent_background = true,
--                 flavour = "mocha",
--                 term_colors = true,
--                 --         custom_highlights = function(colors)
--                 --             return {
--                 --                 Cursor = { fg = colors.base, bg = colors.rosewater },
--                 --                 -- -- Comment = { fg = colors.flamingo },
--                 --                 -- CursorLineNr = { bg = u.blend(colors.overlay0, colors.base, 0.75), style = { "bold" } },
--                 --                 -- CursorLine = { bg = u.blend(colors.overlay0, colors.base, 0.45) },
--                 --                 -- LspReferenceText = { bg = colors.surface2 },
--                 --                 -- LspReferenceWrite = { bg = colors.surface2 },
--                 --                 -- LspReferenceRead = { bg = colors.surface2 },
--                 --             }
--                 --         end,
--             })
--         end,
--     },
-- }
