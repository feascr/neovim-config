return {

    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },

    -- `luvit-meta` provied types
    {
        "Bilal2453/luvit-meta",
        lazy = true,
    },

    -- Main LSP Configuration
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            -- NOTE: carefull wit this since if cmp is not set up properly will result in errors
            "hrsh7th/cmp-nvim-lsp",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),

                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or "n"
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-t>.
                    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

                    -- Find references for the word under your cursor.
                    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map("<leader>ss", require("telescope.builtin").lsp_document_symbols, "[s]search [s]ymbols")

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    map(
                        "<leader>sS",
                        require("telescope.builtin").lsp_dynamic_workspace_symbols,
                        "[s]earch workspace [S]ymbols"
                    )

                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

                    -- This is not Goto Definition, this is Goto Declaration.
                    -- For example, in C this would take you to the header.
                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                    map("gK", vim.lsp.buf.signature_help, "Goto Signature", { "n", "x" })
                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                        local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd("LspDetach", {
                            group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({
                                    group = "lsp-highlight",
                                    buffer = event2.buf,
                                })
                            end,
                        })
                    end

                    -- The following code creates a keymap to toggle inlay hints in your
                    -- code, if the language server you are using supports them
                    --
                    -- This may be unwanted, since they displace some of your code
                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        map("<leader>th", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({
                                bufnr = event.buf,
                            }))
                        end, "[T]oggle Inlay [H]ints")
                    end
                end,
            })
            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            capabilities =
                vim.tbl_deep_extend("force", capabilities, has_cmp and cmp_nvim_lsp.default_capabilities() or {})

            local servers = {
                clangd = {},
                ruff = {
                    on_attach = function(client, bufnr)
                        client.server_capabilities.hoverProvider = false
                        local bufopts = { noremap = true, silent = true, buffer = bufnr }
                        local org_imports = function()
                            vim.lsp.buf.code_action({
                                apply = true,
                                context = {
                                    only = { "source.organizeImports" },
                                    diagnostics = {},
                                },
                            })
                        end
                        vim.keymap.set(
                            "n",
                            "<leader>co",
                            org_imports,
                            vim.tbl_extend("force", bufopts, { desc = "Organize Imports" })
                        )
                    end,
                },
                pyright = {
                    settings = {
                        pyright = {
                            disableOrganizeImports = true,
                        },
                    },
                    version = "1.1.377",
                },
                marksman = {},
                rust_analyzer = {},
                jsonls = {},
                lua_ls = {
                    -- cmd = {...},
                    -- filetypes = { ...},
                    -- capabilities = {},
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = {
                                    "bit",
                                    "vim",
                                    "it",
                                    "describe",
                                    "before_each",
                                    "after_each",
                                },
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                },
                dockerls = {},
                docker_compose_language_service = {},
                yamlls = {},
            }

            -- Ensure the servers and tools above are installed
            --  To check the current status of installed tools and/or manually install
            --  other tools, you can run
            --    :Mason
            require("mason").setup()

            -- You can add other tools here that you want Mason to install
            -- for you, so that they are available from within Neovim.
            -- local ensure_installed = vim.tbl_keys(servers or {})
            -- TODO: seperate in other file for easier configuration of what
            -- needs to be installed from linting, lsp, formatting
            local ensure_installed = {
                "markdownlint",
                "markdown-toc",
            }

            -- Loop through the servers table and add server with its version
            for server, config in pairs(servers) do
                if config.version then
                    table.insert(ensure_installed, { server, version = config.version })
                    servers[server].version = nil
                else
                    table.insert(ensure_installed, server) -- Add server without version
                end
            end

            vim.list_extend(ensure_installed, {
                "stylua", -- Used to format Lua code
            })
            require("mason-tool-installer").setup({
                ensure_installed = ensure_installed,
            })

            local handler = function(server_name)
                local server = servers[server_name] or {}
                -- This handles overriding only values explicitly passed
                -- by the server configuration above. Useful when disabling
                -- certain features of an LSP (for example, turning off formatting for tsserver)
                server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                require("lspconfig")[server_name].setup(server)
            end
            require("mason-lspconfig").setup({
                -- ensure_installed = ensure_installed,
                handlers = {
                    handler,
                },
            })
        end,
    },
}
