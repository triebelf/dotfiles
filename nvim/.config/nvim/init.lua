-- allow project-specific configuration
vim.opt.exrc = true

-- comma is the leader key
vim.g.mapleader = ","

-- key mappings ordered by NEO keyboard layout
local keymap_opts = { noremap = true, silent = true }
local tele = require("telescope.builtin")
vim.keymap.set({ "n", "v" }, "<leader><tab><tab>", vim.cmd.tabnew, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>x", tele.diagnostics, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>v", vim.cmd.Outline, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>l", vim.cmd.Lexplore, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>c", tele.commands, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>w", vim.cmd.OutlineFocus, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>k", vim.cmd.cprev, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>h", vim.cmd.ClangdSwitchSourceHeader, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>g", tele.lsp_definitions, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>f", require("conform").format, keymap_opts)
--vim.keymap.set({ "n", "v" }, "<leader>q", tele.builtin, keymap_opts)

vim.keymap.set({ "n", "v" }, "<leader>u", tele.resume, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>i", tele.lsp_implementations, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>e", vim.diagnostic.open_float, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>o", tele.git_files, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>s", tele.lsp_dynamic_workspace_symbols, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>n", vim.lsp.buf.rename, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>r", tele.lsp_references, keymap_opts)
-- open type hierarchy, then use "gd" to just to type
vim.keymap.set({ "n", "v" }, "<leader>t", vim.cmd.ClangdTypeHierarchy, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>d", vim.lsp.buf.hover, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>y", tele.registers, keymap_opts)

vim.keymap.set({ "n", "v" }, "<leader>p", tele.lsp_incoming_calls, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>z", tele.find_files, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>b", tele.buffers, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>m", tele.oldfiles, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>,", tele.live_grep, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>.", tele.grep_string, keymap_opts)
vim.keymap.set({ "n", "v" }, "<leader>j", vim.cmd.cnext, keymap_opts)

vim.opt.clipboard = vim.opt.clipboard + "unnamedplus"

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
vim.opt.smartcase = true

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
vim.cmd([[colorscheme modus]])
--vim.o.background = "light"

-- lualine.nvim
require("lualine").setup({ options = { icons_enabled = false } })

-- nvim-treesitter
require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})

-- folding
--vim.opt.foldmethod = "expr"
--vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
--vim.opt.foldtext = ""
--vim.opt.foldlevel = 99
--vim.opt.foldlevelstart = 3
--vim.opt.foldnestmax = 4

-- plenary.nvim
-- telescope.nvim
require("telescope").setup({
    defaults = { layout_strategy = "vertical", layout_config = { width = 0.95 } },
    pickers = {
        lsp_dynamic_workspace_symbols = { fname_width = 60 },
        live_grep = {
            additional_args = function(opts)
                return { "--hidden", "--iglob", "!.git" }
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
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            require("clangd_extensions.cmp_scores"),
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
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

-- mason
require("mason").setup()
require("mason-lspconfig").setup({ automatic_installation = true })

-- nvim-lspconfig
vim.lsp.set_log_level("off")
local lsp_defaults = require("lspconfig").util.default_config
lsp_defaults.capabilities =
    vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())
require("lspconfig").bashls.setup({ flags = { debounce_text_changes = 150 } })
require("lspconfig").clangd.setup({
    cmd = {
        "clangd",
        "--offset-encoding=utf-16",
        "--limit-references=0",
        "--limit-results=0",
        "--rename-file-limit=0",
        "--completion-style=detailed",
    },
    flags = { debounce_text_changes = 150 },
})
require("clangd_extensions").setup({})

require("lspconfig").cmake.setup({ flags = { debounce_text_changes = 150 } })
require("lspconfig").dockerls.setup({ flags = { debounce_text_changes = 150 } })
require("lspconfig").esbonio.setup({ flags = { debounce_text_changes = 150 } })
require("lspconfig").typos_lsp.setup({
    root_dir = require("lspconfig").util.root_pattern("pyproject.toml"),
    flags = { debounce_text_changes = 150 },
})
require("lspconfig").jsonls.setup({ flags = { debounce_text_changes = 150 } })
require("lspconfig").lemminx.setup({ flags = { debounce_text_changes = 150 } })
require("lspconfig").taplo.setup({ flags = { debounce_text_changes = 150 } })
require("lspconfig").ltex.setup({
    flags = { debounce_text_changes = 150 },
    settings = {
        ltex = {
            enabled = false,
            language = "en-US",
            additionalRules = { motherTongue = "de-DE" },
            dictionary = {
                ["en-US"] = { "deserializability", "deserializable", "deserialization", "serializability" },
            },
        },
    },
})
require("lspconfig").pyright.setup({
    settings = {
        python = { analysis = { autoSearchPaths = true, diagnosticMode = "workspace", useLibraryCodeForTypes = true } },
    },
    flags = { debounce_text_changes = 150 },
})
require("lspconfig").lua_ls.setup({
    settings = {
        Lua = {
            runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
            diagnostics = { globals = { "vim" } },
            workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = true, preloadFileSize = 10000 },
            telemetry = { enable = false },
        },
    },
})
require("lspconfig").yamlls.setup({ flags = { debounce_text_changes = 150 } })

-- nvim-lint
require("lint").linters_by_ft = {
    cmake = { "cmakelint" },
    make = { "checkmake" },
    python = { "mypy", "pylint" },
    sh = { "bash" },
    yaml = { "yamllint" },
}
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
        require("lint").try_lint("cspell")
    end,
})

-- conform.nvim
require("conform").setup({
    formatters_by_ft = {
        cpp = { "clang_format" },
        lua = { "stylua" },
        python = { "isort", "black" },
        sh = { "shellharden" },
        yaml = { "yq" },
    },
})

-- outline
require("outline").setup({ outline_window = { width = 20 }, symbol_folding = { markers = { "+", "⌄" } } })
