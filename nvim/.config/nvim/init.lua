-- comma is the leader key
vim.g.mapleader = ","

-- custom key mappings
local keymap_opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>a", ":LspCodeAction<CR>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>b", ":Telescope buffers<cr>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>c", ":lua ToggleDarkMode()<cr>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>,", ":Telescope live_grep<cr>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>d", ":LspHover<CR>", keymap_opts)
-- see also LspSignatureHelp
vim.api.nvim_set_keymap("n", "<leader>D", ":lua require('neogen').generate()<CR>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>e", ":lua vim.diagnostic.open_float()<CR>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>f", ":LspFormat<CR>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>g", ":LspDefinition<CR>", keymap_opts)
-- see also LspDeclaration, LspTypeDefinition, LspImplementation
vim.api.nvim_set_keymap("n", "<leader>h", ":ClangdSwitchSourceHeader<CR>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>i", ":LspIncomingCalls<CR>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>j", ":lua vim.diagnostic.goto_next()<CR>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>k", ":lua vim.diagnostic.goto_prev()<CR>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>l", ":Lexplore<cr>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>m", ":Telescope oldfiles<cr>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>n", ":LspRename<CR>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>o", ":Telescope git_files<cr>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>r", ":LspReferences<CR>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>s", ":Telescope git_branches<cr>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>t", ":Telescope tags<cr>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>x", ":Telescope diagnostics<cr>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>y", ":Telescope registers<cr>", keymap_opts)
vim.api.nvim_set_keymap("n", "<leader>z", ":Telescope find_files<cr>", keymap_opts)

-- no mouse
vim.opt.mouse = ""

-- persist the undo tree for each file
vim.opt.undofile = true

-- use spaces for tabs
vim.opt.expandtab = true

-- ignore whitespace in diff
vim.opt.diffopt:append("iwhite")

--  ignore case when searching
vim.opt.ignorecase = true

-- NERDtree like setup for netrw
vim.g.netrw_altv = 1
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4
vim.g.netrw_keepdir = 0
--vim.g.netrw_list_hide = vim.fn["netrw_gitignore#Hide"]()
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 20

-- true color support
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.signcolumn = "yes"

-- theme
function ToggleDarkMode()
    if vim.g.light_switch == true then
        vim.g.light_switch = false
        --vim.cmd("colorscheme kanagawa")
        vim.cmd("colorscheme kanagawa-dragon")
    else
        vim.g.light_switch = true
        vim.cmd("colorscheme kanagawa-lotus")
    end
end

--vim.cmd("colorscheme kanagawa")
vim.cmd("colorscheme kanagawa-dragon")

-- lualine.nvim
require("lualine").setup({ options = { icons_enabled = false } })

-- nvim-treesitter
require("nvim-treesitter.configs").setup({ highlight = { enable = true } })

-- vim-gutentags
--vim.g.gutentags_trace = 1
vim.g.gutentags_cache_dir = vim.fn.expand("~/.cache/nvim/ctags/")
vim.g.gutentags_ctags_extra_args = { "--tag-relative=yes", "--fields=+ailmnS" }
vim.g.gutentags_generate_on_new = true
vim.g.gutentags_generate_on_missing = true
vim.g.gutentags_generate_on_write = true
vim.g.gutentags_generate_on_empty_buffer = true
vim.g.gutentags_ctags_exclude = { ".*" }

-- vim-oscyank
vim.cmd([[
		autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankRegister "' | endif
]])

-- plenary.nvim
-- telescope.nvim
require("telescope").setup({
    defaults = { layout_strategy = "vertical" },
    pickers = {
        live_grep = {
            additional_args = function(opts)
                return { "--hidden" }
            end,
        },
    },
})

vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- nvim-cmp
local cmp = require("cmp")
local select_opts = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    completion = { autocomplete = false },
    sources = cmp.config.sources({
        -- cmp-nvim-lsp
        { name = "nvim_lsp" },
        -- cmp-snippy
        { name = "snippy" },
        -- cmp-treesitter
        { name = "treesitter" },
        -- cmp-nvim-lua
        { name = "nvim_lua" },
        -- cmp-buffer
        { name = "buffer" },
    }),
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            local col = vim.fn.col(".") - 1
            if cmp.visible() then
                cmp.select_next_item(select_opts)
            elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
                fallback()
            else
                cmp.complete()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item(select_opts)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    snippet = {
        expand = function(args)
            -- nvim-snippy
            -- vim-snippets
            require("snippy").expand_snippet(args.body)
        end,
    },
})

cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "buffer" } },
})

-- cmp-path
-- cmp-cmdline
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})

-- nvim-lsp-basics
local function on_attach(client, bufnr)
    local basics = require("lsp_basics")
    basics.make_lsp_commands(client, bufnr)
    basics.make_lsp_mappings(client, bufnr)
end

-- nvim-lspconfig
local lsp_defaults = require("lspconfig").util.default_config
lsp_defaults.capabilities = vim.tbl_deep_extend(
    "force",
    lsp_defaults.capabilities,
    require("cmp_nvim_lsp").default_capabilities()
)
require("lspconfig").clangd.setup({ on_attach = on_attach, flags = { debounce_text_changes = 150 } })
require("lspconfig").rust_analyzer.setup({ on_attach = on_attach, flags = { debounce_text_changes = 150 } })
require("lspconfig").dockerls.setup({ on_attach = on_attach, flags = { debounce_text_changes = 150 } })
require("lspconfig").taplo.setup({})
require("lspconfig").jsonls.setup({ on_attach = on_attach, flags = { debounce_text_changes = 150 } })
require("lspconfig").lemminx.setup({ on_attach = on_attach, flags = { debounce_text_changes = 150 } })
require("lspconfig").ltex.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    filetypes = { "bib", "markdown", "org", "plaintex", "rst", "rnoweb", "tex" },
})
require("lspconfig").pyright.setup({
    on_attach = on_attach,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                --typeCheckingMode = "strict",
            },
        },
    },
    flags = { debounce_text_changes = 150 },
})
require("lspconfig").lua_ls.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})
require("lspconfig").yamlls.setup({ on_attach = on_attach, flags = { debounce_text_changes = 150 } })

-- null-ls.nvim
local null_ls = require("null-ls")
null_ls.setup({
    on_attach = on_attach,
    sources = {
        null_ls.builtins.code_actions.shellcheck,
        -- null_ls.builtins.diagnostics.ruff.with({
        --     args = { "-n", "-e", "--line-length", "120", "--stdin-filename", "$FILENAME", "-" },
        -- }),
        null_ls.builtins.diagnostics.flake8.with({
            args = { "--max-line-length", "120", "--format", "default", "--stdin-display-name", "$FILENAME", "-" },
        }),
        null_ls.builtins.diagnostics.mypy.with({
            args = function(params)
                return {
                    "--strict",
                    "--disallow-any-unimported",
                    "--hide-error-context",
                    "--no-color-output",
                    "--show-column-numbers",
                    "--show-error-codes",
                    "--no-error-summary",
                    "--no-pretty",
                    "--shadow-file",
                    params.bufname,
                    params.temp_path,
                    params.bufname,
                }
            end,
        }),
        null_ls.builtins.diagnostics.pylint.with({
            cwd = function(params)
                return params.root
            end,
            args = { "--max-line-length", "120", "--from-stdin", "$FILENAME", "-f", "json" },
        }),
        null_ls.builtins.diagnostics.shellcheck,
        --null_ls.builtins.diagnostics.yamllint,
        null_ls.builtins.diagnostics.zsh,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort.with({
            args = { "--quiet", "--profile", "black", "--line-width", "120", "-" },
        }),
        null_ls.builtins.formatting.shellharden,
        null_ls.builtins.formatting.stylua.with({
            extra_args = { "--column-width", "120", "--indent-type", "Spaces" },
        }),
        null_ls.builtins.formatting.clang_format,
    },
})

-- neogen
require("neogen").setup({
    languages = { python = { template = { annotation_convention = "reST" } } },
})
