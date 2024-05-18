-- comma is the leader key
vim.g.mapleader = ","

-- custom key mappings
local keymap_opts = { noremap = true, silent = true }
local tele = require("telescope.builtin")
-- open files
vim.keymap.set("n", "<leader>b", tele.buffers, keymap_opts)
vim.keymap.set("n", "<leader>m", tele.oldfiles, keymap_opts)
vim.keymap.set("n", "<leader>o", tele.git_files, keymap_opts)
vim.keymap.set("n", "<leader>z", tele.find_files, keymap_opts)
vim.keymap.set("n", "<leader>l", vim.cmd.Lexplore, keymap_opts)
vim.keymap.set("n", "<leader><tab><tab>", vim.cmd.tabnew, keymap_opts)

-- search
vim.keymap.set("n", "<leader>,", tele.live_grep, keymap_opts)
vim.keymap.set("n", "<leader>q", tele.lsp_dynamic_workspace_symbols, keymap_opts)

-- navigation
vim.keymap.set("n", "<leader>h", vim.cmd.ClangdSwitchSourceHeader, keymap_opts)
vim.keymap.set("n", "<leader>v", vim.cmd.Outline, keymap_opts)
vim.keymap.set("n", "<leader>t", vim.cmd.ClangdTypeHierarchy, keymap_opts)
vim.keymap.set("n", "<leader>c", vim.cmd.ClangdAST, keymap_opts)
vim.keymap.set("n", "<leader>g", tele.lsp_definitions, keymap_opts)
vim.keymap.set("n", "<leader>r", tele.lsp_references, keymap_opts)

-- editing
vim.keymap.set("n", "<leader>a", vim.cmd.LspCodeAction, keymap_opts)
vim.keymap.set({ "n", "v", "o" }, "<leader>f", vim.lsp.buf.format, keymap_opts)
vim.keymap.set("n", "<leader>n", vim.cmd.LspRename, keymap_opts)
vim.keymap.set("n", "<leader>y", tele.registers, keymap_opts)

-- info
vim.keymap.set("n", "<leader>d", vim.cmd.LspHover, keymap_opts)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, keymap_opts)
vim.keymap.set("n", "<leader>x", tele.diagnostics, keymap_opts)
vim.keymap.set("n", "<leader>j", vim.diagnostic.goto_next, keymap_opts)
vim.keymap.set("n", "<leader>k", vim.diagnostic.goto_prev, keymap_opts)

-- no mouse
vim.opt.mouse = ""

-- persist the undo tree for each file
vim.opt.undofile = true

-- place spaces upon receiving a whitespace command or a tab keypress
vim.opt.expandtab = true
-- How many columns wide is a tab character worth?
vim.opt.tabstop = 4
-- Referred to for “levels of indentation”
vim.opt.shiftwidth = 4

vim.opt.smartindent = true
vim.opt.textwidth = 120

-- ignore whitespace in diff
vim.opt.diffopt:append("iwhite")

-- ignore case when searching
vim.opt.ignorecase = true

-- enable spell checking
vim.opt.spelllang = "en_us"
--vim.opt.spell = true
vim.opt.spelloptions = "camel"

-- NERDtree like setup for netrw
vim.g.netrw_altv = 1
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4
vim.g.netrw_keepdir = 0
vim.g.netrw_list_hide = "__pycache__"
--vim.g.netrw_list_hide = vim.fn["netrw_gitignore#Hide"]()
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 20

-- true color support
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.signcolumn = "yes"

-- theme
vim.cmd("colorscheme tokyonight")
-- colorscheme tokyonight
-- colorscheme tokyonight-night
-- colorscheme tokyonight-storm
-- colorscheme tokyonight-day
-- colorscheme tokyonight-moon

-- lualine.nvim
require("lualine").setup({ options = { icons_enabled = false, theme = "tokyonight" } })

-- nvim-treesitter
require("nvim-treesitter.configs").setup({ highlight = { enable = true } })
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.cmd([[ set nofoldenable]])

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
    --pickers = {
    --    live_grep = {
    --        additional_args = function(opts)
    --            return { "--hidden" }
    --        end,
    --    },
    --},
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

-- mason
require("mason").setup()
require("mason-lspconfig").setup({ automatic_installation = true })

-- nvim-lspconfig
local lsp_defaults = require("lspconfig").util.default_config
lsp_defaults.capabilities =
    vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())
require("lspconfig").bashls.setup({ on_attach = on_attach, flags = { debounce_text_changes = 150 } })
require("lspconfig").clangd.setup({ on_attach = on_attach, flags = { debounce_text_changes = 150 } })
require("clangd_extensions").setup({})
require("lspconfig").cmake.setup({ on_attach = on_attach, flags = { debounce_text_changes = 150 } })
require("lspconfig").dockerls.setup({ on_attach = on_attach, flags = { debounce_text_changes = 150 } })
require("lspconfig").esbonio.setup({ on_attach = on_attach, flags = { debounce_text_changes = 150 } })
require("lspconfig").typos_lsp.setup({ on_attach = on_attach, flags = { debounce_text_changes = 150 } })
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
                path = vim.split(package.path, ";"),
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files and plugins
                library = { vim.env.VIMRUNTIME },
                checkThirdParty = true,
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
        null_ls.builtins.diagnostics.yamllint,
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

-- outline
require("outline").setup({ symbol_folding = { markers = { "+", "⌄" } } })
