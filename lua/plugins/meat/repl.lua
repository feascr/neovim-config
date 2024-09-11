-- repl
return {
    "Vigemus/iron.nvim",
    keys = {
        { "<leader>i", vim.cmd.IronRepl, desc = "󱠤 Toggle REPL" },
        { "<leader>I", vim.cmd.IronRestart, desc = "󱠤 Restart REPL" },

        -- TODO: change keymaps, this is unsuable
        { "+", mode = { "n", "x" }, desc = "󱠤 Send-to-REPL Operator" },
        { "++", desc = "󱠤 Send Line to REPL" },
    },

    main = "iron.core",

    opts = {
        keymaps = {
            send_line = "++",
            visual_send = "+",
            send_motion = "+",
        },
        config = {
            repl_open_cmd = "horizontal bot 10 split",

            repl_definition = {
                python = {
                    command = function()
                        local ipythonAvailable = vim.fn.executable("ipython") == 1
                        local binary = ipythonAvailable and "ipython" or "python3"
                        return { binary }
                    end,
                },
            },
        },
    },
}
