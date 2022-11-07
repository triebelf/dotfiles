-- persist the undo tree for each file
vim.opt.undofile = true

-- comma is the leader key
vim.g.mapleader = ","

-- toggle paste mode with ,p
vim.opt.pastetoggle = "<leader>p"
vim.opt.mouse = ""

-- use spaces for tabs
vim.opt.expandtab = true

-- ignore whitespace in diff
vim.opt.diffopt:append("iwhite")

--  ignore case when searching
vim.opt.ignorecase = true

vim.opt.wildignore = {
    ".*\\.egg-info",
    "\\.eggs",
    ".git",
    ".mypy_cache",
    ".*\\.pyc$",
    "__pycache__",
}

-- NERDtree like setup (commands :Ex :Sex :Vex)
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 15
vim.g.netrw_banner = 0
vim.g.netrw_list_hide = table.concat(vim.opt.wildignore:get(), ",")
vim.g.netrw_hide = 1
vim.g.netrw_keepdir = 0

-- true color support
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

-- theme
vim.opt.background = light
vim.cmd("colorscheme melange")

-- lualine.nvim
require("lualine").setup({ options = { icons_enabled = false } })

-- nvim-treesitter
require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
})

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
    autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif
]])

vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- nvim-cmp
local cmp = require("cmp")
cmp.setup({
    completion = { autocomplete = false },
    sources = cmp.config.sources({
        -- cmp-nvim-lsp
        { name = "nvim_lsp" },
        -- cmp-buffer
        --{ name = "buffer" },
        -- cmp-snippy
        { name = "snippy" },
        -- cmp-treesitter
        { name = "treesitter" },
        -- cmp-nvim-tags
        -- { name = "tags" },
        -- cmp-nvim-lua
        { name = "nvim_lua" },
    }),
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        -- ["<s-tab>"] = cmp.mapping.select_prev_item(),
        -- ["<tab>"] = cmp.mapping.select_next_item(),
    }),
    snippet = {
        expand = function(args)
            -- nvim-snippy
            -- vim-snippets
            require("snippy").expand_snippet(args.body)
        end,
    },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", { mapping = cmp.mapping.preset.cmdline(), sources = { { name = "buffer" } } })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp-path
-- cmp-cmdline
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})

-- plenary.nvim
-- telescope.nvim
require("telescope").setup({ defaults = { layout_strategy = "vertical" } })

-- opening files
vim.api.nvim_set_keymap("n", "<leader>b", "<cmd>Telescope buffers<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>,", "<cmd>Telescope live_grep<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>.", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>m", "<cmd>Telescope oldfiles<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>o", "<cmd>Telescope git_files<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>s", "<cmd>Telescope git_branches<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>Telescope tags<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>x", "<cmd>Telescope diagnostics<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>y", "<cmd>Telescope registers<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>z", "<cmd>Telescope find_files<cr>", { noremap = true })

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("n", "<leader>d", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
    buf_set_keymap("n", "<leader>g", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "<leader>j", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<leader>k", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "<leader>n", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<leader>r", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- nvim-lspconfig
require("lspconfig").clangd.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
})

require("lspconfig").dockerls.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
})

require("lspconfig").jsonls.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
})

require("lspconfig").lemminx.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
})

require("lspconfig").ltex.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    filetypes = { "bib", "markdown", "org", "plaintex", "rst", "rnoweb", "tex" },
})

require("lspconfig").pyright.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
})

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
require("lspconfig").sumneko_lua.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT", path = runtime_path },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
        },
    },
})

require("lspconfig").yamlls.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    settings = {
        yaml = { format = { enable = true, proseWrap = "Always", printWidth = 120 } },
        redhat = {
            telemetry = {
                enabled = false,
            },
        },
    },
})

-- null-ls.nvim
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.shellcheck,
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
    },
})
