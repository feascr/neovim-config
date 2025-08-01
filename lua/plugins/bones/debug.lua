---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
    local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
    config = vim.deepcopy(config)
    ---@cast args string[]
    config.args = function()
        local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
        return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
    end
    return config
end

return {
    {
        "mfussenegger/nvim-dap",
        recommended = true,
        desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

        dependencies = {
            "rcarriga/nvim-dap-ui",
            -- virtual text for the debugger
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {},
            },
            "mfussenegger/nvim-dap-python",
        },

        keys = {
            { "<leader>d", "", desc = "Debug", mode = { "n", "v" } },
            {
                "<leader>dB",
                function()
                    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                desc = "Breakpoint Condition",
            },
            {
                "<leader>db",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Toggle Breakpoint",
            },
            {
                "<leader>dc",
                function()
                    require("dap").continue()
                end,
                desc = "Continue",
            },
            {
                "<leader>da",
                function()
                    require("dap").continue({ before = get_args })
                end,
                desc = "Run with Args",
            },
            {
                "<leader>dC",
                function()
                    require("dap").run_to_cursor()
                end,
                desc = "Run to Cursor",
            },
            {
                "<leader>dg",
                function()
                    require("dap").goto_()
                end,
                desc = "Go to Line (No Execute)",
            },
            {
                "<leader>di",
                function()
                    require("dap").step_into()
                end,
                desc = "Step Into",
            },
            {
                "<leader>dj",
                function()
                    require("dap").down()
                end,
                desc = "Down",
            },
            {
                "<leader>dk",
                function()
                    require("dap").up()
                end,
                desc = "Up",
            },
            {
                "<leader>dl",
                function()
                    require("dap").run_last()
                end,
                desc = "Run Last",
            },
            {
                "<leader>do",
                function()
                    require("dap").step_out()
                end,
                desc = "Step Out",
            },
            {
                "<leader>dO",
                function()
                    require("dap").step_over()
                end,
                desc = "Step Over",
            },
            {
                "<leader>dp",
                function()
                    require("dap").pause()
                end,
                desc = "Pause",
            },
            {
                "<leader>dr",
                function()
                    require("dap").repl.toggle()
                end,
                desc = "Toggle REPL",
            },
            {
                "<leader>ds",
                function()
                    require("dap").session()
                end,
                desc = "Session",
            },
            {
                "<leader>dt",
                function()
                    require("dap").terminate()
                end,
                desc = "Terminate",
            },
            {
                "<leader>dw",
                function()
                    require("dap.ui.widgets").hover()
                end,
                desc = "Widgets",
            },
        },

        config = function()
            local dap = require("dap")
            dap.adapters.cppdbg = {
                id = "cppdbg",
                type = "executable",
                command = "/home/feascr/vscode_extensions/extension/debugAdapters/bin/OpenDebugAD7",
            }
            dap.configurations.cpp = {
                {
                    name = "Launch file",
                    type = "cppdbg",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtEntry = true,
                },
                {
                    name = "Attach to gdbserver :1234",
                    type = "cppdbg",
                    request = "launch",
                    MIMode = "gdb",
                    miDebuggerServerAddress = "localhost:1234",
                    miDebuggerPath = "/usr/bin/gdb",
                    cwd = "${workspaceFolder}",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                },
            }
            dap.configurations.c = dap.configurations.cpp

            vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

            -- setup dap config by VsCode launch.json file
            -- local vscode = require("dap.ext.vscode")
            -- local json = require("plenary.json")
            -- ---@diagnostic disable-next-line: duplicate-set-field
            -- vscode.json_decode = function(str)
            --     return vim.json.decode(json.json_strip_comments(str))
            -- end
            --
            -- -- Extends dap.configurations with entries read from .vscode/launch.json
            -- if vim.fn.filereadable(".vscode/launch.json") then
            --     vscode.load_launchjs()
            -- end

            -- python dap
            local venv = os.getenv("VIRTUAL_ENV")

            -- Check if the virtual environment is active
            if venv then
                -- Construct the path to the Python interpreter inside the virtual environment
                local venvPythonPath = venv .. "/bin/python" -- Adjust for Windows if needed

                -- Configure dap-python to use the Python interpreter from the active virtual environment
                require("dap-python").setup(venvPythonPath)
                -- else
                --     vim.notify("No active virtual environment found.")
            end
        end,
    },

    -- fancy UI for the debugger
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        -- stylua: ignore
        keys = {
            { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
            { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
        },
        opts = {},
        config = function(_, opts)
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup(opts)
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open({})
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close({})
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close({})
            end
        end,
    },
    --
    -- -- mason.nvim integration
    -- {
    --     "jay-babu/mason-nvim-dap.nvim",
    --     dependencies = "mason.nvim",
    --     cmd = { "DapInstall", "DapUninstall" },
    --     opts = {
    --         -- Makes a best effort to setup the various debuggers with
    --         -- reasonable debug configurations
    --         automatic_installation = true,
    --
    --         -- You can provide additional configuration to the handlers,
    --         -- see mason-nvim-dap README for more information
    --         handlers = {},
    --
    --         -- You'll need to check that you have the required things installed
    --         -- online, please don't ask me how to install them :)
    --         ensure_installed = {
    --             -- Update this to ensure that you have the debuggers for the langs you want
    --         },
    --     },
    --     -- mason-nvim-dap is loaded when nvim-dap loads
    --     config = function() end,
    -- },

    -- Don't mess up DAP adapters provided by nvim-dap-python
    -- {
    --     "jay-babu/mason-nvim-dap.nvim",
    --     optional = true,
    --     opts = {
    --         handlers = {
    --             python = function() end,
    --         },
    --     },
    -- },
}
