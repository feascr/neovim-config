-- Setup lazy.nvim
require("lazy").setup({

    -- bones layer plugins
    -- must
    require("plugins.bones.treesitter"),
    require("plugins.bones.telescope"),
    require("plugins.bones.lsp"),
    require("plugins.bones.debug"),
    require("plugins.bones.formatter"),
    require("plugins.bones.lint"),
    --
    -- MEAT layer plugins
    -- should be useful
    require("plugins.meat.repl"),
    require("plugins.meat.mini"),
    require("plugins.meat.autopairs"),
    require("plugins.meat.which_key"),
    require("plugins.meat.cmp"),
    -- TODO:: needs good configuration to make it work for lsp and dap
    -- require('plugins.meat.venv_selector'),
    --
    -- SKIN layer plugins
    -- mostly UI
    require("plugins.skin.todo_comments_highlight"),
    require("plugins.skin.theme"),
    require("plugins.skin.gitsigns"),
    require("plugins.skin.mini_skin"),
    require("plugins.skin.indent_line"),
    require("plugins.skin.harpoon2"),
    require("plugins.skin.fidget"),
    require("plugins.skin.undotree"),
    require("plugins.skin.trouble"),
    require("plugins.skin.markdown_preview"),
    -- Configure any other settings here. See the documentation for more details.
    -- automatically check for plugin updates
    checker = { enabled = false },
})
