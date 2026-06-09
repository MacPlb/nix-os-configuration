return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lspconfig = require("lspconfig")

        -- Minimal on_attach — only keybinds, no auto-format
        local on_attach = function(client, bufnr)
            local map = function(keys, func, desc)
                vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
            end

            map("gd", vim.lsp.buf.definition, "Go to definition")
            map("gr", vim.lsp.buf.references, "References")
            map("K", vim.lsp.buf.hover, "Hover info")
            map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
            map("<leader>ca", vim.lsp.buf.code_action, "Code action")
            map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
            map("]d", vim.diagnostic.goto_next, "Next diagnostic")

            -- Disable heavy features for performance
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end

        -- Shared capabilities (no completion engine — keep it light)
        local capabilities = vim.lsp.protocol.make_client_capabilities()

        -- Skip LSP for big files
        local should_attach = function(bufnr)
            return not vim.b[bufnr].large_buf
        end

        -- Go
        lspconfig.gopls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            on_new_config = function(config, root_dir)
                -- Keep gopls lightweight
                config.settings = {
                    gopls = {
                        analyses = { unusedparams = true },
                        staticcheck = false,
                        gofumpt = false,
                    },
                }
            end,
        })

        -- Python
        lspconfig.pyright.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "off",  -- syntax only, no deep type checking
                        autoImportCompletions = false,
                        diagnosticMode = "openFilesOnly",
                    },
                },
            },
        })

        -- C# / .NET
        lspconfig.omnisharp.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            cmd = { "OmniSharp", "--languageserver" },
            settings = {
                FormattingOptions = { EnableEditorConfigSupport = false },
                RoslynExtensionsOptions = {
                    EnableAnalyzersSupport = false,
                    EnableImportCompletion = false,
                },
            },
        })

        -- Diagnostics appearance
        vim.diagnostic.config({
            virtual_text = { spacing = 4, prefix = "●" },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
        })
    end,
}
