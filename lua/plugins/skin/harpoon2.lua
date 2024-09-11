return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup()

        vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "[H]arpoon [A]dd" })
        vim.keymap.set(
            "n",
            "<leader>hu",
            function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
            { desc = "[H]arpoon [U]I" }
        )

        -- vim.keymap.set("n", "<C-h>", function() harpoon.list().select(1) end, {desc = "[H]arpoon [A]dd"})
        -- vim.keymap.set("n", "<C-t>", function() harpoon.list().select(2) end, {desc = "[H]arpoon [A]dd"})
        -- vim.keymap.set("n", "<C-n>", function() harpoon.list().select(3) end, {desc = "[H]arpoon [A]dd"})
        -- vim.keymap.set("n", "<C-s>", function() harpoon.list().select(4) end, {desc = "[H]arpoon [A]dd"})
        -- vim.keymap.set("n", "<leader><C-h>", function() harpoon.list().replace_at(1) end, {desc = "[H]arpoon [A]dd"})
        -- vim.keymap.set("n", "<leader><C-t>", function() harpoon.list().replace_at(2) end, {desc = "[H]arpoon [A]dd"})
        -- vim.keymap.set("n", "<leader><C-n>", function() harpoon.list().replace_at(3) end, {desc = "[H]arpoon [A]dd"})
        -- vim.keymap.set("n", "<leader><C-s>", function() harpoon.list().replace_at(4) end, {desc = "[H]arpoon [A]dd"})
    end,
}
