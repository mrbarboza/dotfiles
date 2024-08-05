return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",

        {'fatih/vim-go', run = ':GoUpdateBinaries'},
    },
    config = function()
        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
                "pyright",
                "emmet_ls",
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ['gopls'] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.gopls.setup{
                        cmd = {"gopls", "serve"},
                        settings = {
                            gopls = {
                                analyses = {
                                    unusedparams = true
                                },
                                staticcheck = true,
                            },
                        },
                        on_attach = function(client, bufnr)
                            local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
                            local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

                            buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

                            local opts = { noremap=true, silent=true }

                            buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
                            buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
                            buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
                            buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
                            buf_set_keymap('n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
                            buf_set_keymap('n', '<space>wa', '<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
                            buf_set_keymap('n', '<space>wr', '<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
                            buf_set_keymap('n', '<space>wl', '<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
                            buf_set_keymap('n', '<space>D', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
                            buf_set_keymap('n', '<space>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
                            buf_set_keymap('n', '<space>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
                            buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
                            buf_set_keymap('n', '<space>e', '<Cmd>lua vim.diagnostic.open_float()<CR>', opts)
                            buf_set_keymap('n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
                            buf_set_keymap('n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts)
                            buf_set_keymap('n', '<space>q', '<Cmd>lua vim.diagnostic.setloclist()<CR>', opts)
                            buf_set_keymap('n', '<space>f', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)

                            if client.server_capabilities.documentFormatingProvider then
                                vim.cmd([[
                                        augroup formatting
                                            autocmd! * <buffer>
                                            autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
                                        augroup END
                                    ]])
                            end

                            if client.server_capabilities.documentHighlightingProvider then
                                vim.cmd([[
                                        augroup lsp_document_highlight
                                            autocmd! * <buffer>
                                            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                                            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                                        augroup END
                                    ]])
                            end

                            vim.api.nvim_create_autocmd('BufWritePre', {
                                pattern = { "*.go" },
                                callback = function()
                                    local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
                                    params.context = { only = { "source.organizeImports" } }

                                    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
                                    for _, res in pairs(result or {}) do
                                        for _, r in pairs(res.result or {}) do
                                            if r.edit then
                                                vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
                                            else
                                                vim.lsp.buf.execute_command(r.command)
                                            end
                                        end
                                    end
                                end,
                            })
                        end,
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<C-y>"] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.replace,
                    select = true,
                },
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
            }, {
                { name = "buffer" },
            })
        })

        vim.diagnostic.config({
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
