-- spellchecker: disable

vim.cmd([[colorscheme modus]])
--vim.o.background = "light"

vim.g.netrw_altv = 1
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4
vim.g.netrw_keepdir = 0
vim.g.netrw_list_hide = "__pycache__"
--vim.g.netrw_list_hide = vim.fn["netrw_gitignore#Hide"]()
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 20

vim.opt.clipboard:append("unnamedplus")
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.o.cursorline = true
vim.opt.diffopt:append("iwhite")
vim.o.expandtab = true
vim.o.exrc = true
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevelstart = 3
vim.o.foldmethod = "expr"
vim.o.foldtext = ""
vim.o.ignorecase = true
vim.o.mouse = ""
vim.o.number = true
vim.o.shiftround = true
vim.o.shiftwidth = 0
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.softtabstop = -1
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.textwidth = 120
vim.o.undofile = true

vim.filetype.add({
    pattern = {
        [".+cpp.*"] = "cpp",
        [".+hpp.*"] = "cpp",
    },
})

vim.diagnostic.config({ virtual_text = true })

require("lualine").setup({ options = { icons_enabled = false } })

require("outline").setup({ outline_window = { width = 20 }, symbol_folding = { markers = { "+", "⌄" } } })

require("nvim-treesitter.configs").setup({
    highlight = { enable = true, additional_vim_regex_highlighting = false },
})

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

-- LSPs configuration
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

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})

vim.lsp.set_log_level("off")

vim.lsp.config("*", {
    capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities() -- TODO seems to be deprecated
    ),
})

vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--offset-encoding=utf-16",
        "--limit-references=0",
        "--limit-results=0",
        "--rename-file-limit=0",
        "--completion-style=detailed",
    },
})

vim.lsp.config("ltex", {
    settings = {
        ltex = { enabled = false, language = "en-US", additionalRules = { motherTongue = "de-DE" } },
    },
})

-- TODO test
vim.lsp.config("pyright", {
    settings = {
        python = {
            analysis = { autoSearchPaths = true, diagnosticMode = "workspace", useLibraryCodeForTypes = true },
        },
    },
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
            diagnostics = { globals = { "vim" } },
            workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = true, preloadFileSize = 10000 },
            telemetry = { enable = false },
        },
    },
})

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "bashls",
        "clangd",
        "cmake",
        "dockerls",
        "esbonio",
        "jsonls",
        "lemminx",
        "ltex",
        "lua_ls",
        "pyright",
        "taplo",
        "yamlls",
    },
})
require("clangd_extensions").setup({})

require("lint").linters_by_ft = {
    make = { "checkmake" },
    python = { "mypy", "pylint" },
    rst = { "rstcheck" },
    sh = { "bash" },
    yaml = { "yamllint" },
}
-- TODO this doesn't work on fresh installation
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
        require("lint").try_lint("cspell")
    end,
})

require("conform").setup({
    formatters_by_ft = {
        cpp = { "clang_format" },
        lua = { "stylua" },
        python = { "isort", "black" },
        sh = { "shellharden" },
        yaml = { "yq" },
    },
})

-- key mappings ordered by NEO keyboard layout
vim.g.mapleader = ","
local tele = require("telescope.builtin")
vim.keymap.set({ "n", "v" }, "<leader>x", tele.diagnostics)
vim.keymap.set({ "n", "v" }, "<leader>v", vim.cmd.Outline)
vim.keymap.set({ "n", "v" }, "<leader>c", tele.commands)
vim.keymap.set({ "n", "v" }, "<leader>w", vim.cmd.OutlineFocus)
vim.keymap.set({ "n", "v" }, "<leader>k", vim.cmd.cprev)
vim.keymap.set({ "n", "v" }, "<leader>h", vim.cmd.ClangdSwitchSourceHeader)
vim.keymap.set({ "n", "v" }, "<leader>g", tele.lsp_definitions)
vim.keymap.set({ "n", "v" }, "<leader>f", require("conform").format)
vim.keymap.set({ "n", "v" }, "<leader>q", tele.builtin)
vim.keymap.set({ "n", "v" }, "<leader>ß", tele.spell_suggest)
vim.keymap.set({ "n", "v" }, "<leader>u", tele.resume)
vim.keymap.set({ "n", "v" }, "<leader>i", tele.lsp_implementations) -- gri
vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action) -- gra
vim.keymap.set({ "n", "v" }, "<leader>e", vim.diagnostic.open_float) -- Ctrl-W d
vim.keymap.set({ "n", "v" }, "<leader>o", tele.git_files)
vim.keymap.set({ "n", "v" }, "<leader>s", tele.lsp_dynamic_workspace_symbols)
vim.keymap.set({ "n", "v" }, "<leader>n", vim.lsp.buf.rename) -- grn
vim.keymap.set({ "n", "v" }, "<leader>r", tele.lsp_references) -- grr
vim.keymap.set({ "n", "v" }, "<leader>t", vim.cmd.ClangdTypeHierarchy) -- use "gd" to just to entry
vim.keymap.set({ "n", "v" }, "<leader>d", vim.lsp.buf.hover) -- K or gO or Ctrl-S
vim.keymap.set({ "n", "v" }, "<leader>y", tele.registers)
vim.keymap.set({ "n", "v" }, "<leader>p", tele.lsp_incoming_calls)
vim.keymap.set({ "n", "v" }, "<leader>z", tele.find_files)
vim.keymap.set({ "n", "v" }, "<leader>b", tele.buffers)
vim.keymap.set({ "n", "v" }, "<leader>m", tele.oldfiles)
vim.keymap.set({ "n", "v" }, "<leader>,", tele.live_grep)
vim.keymap.set({ "n", "v" }, "<leader>.", tele.grep_string)
vim.keymap.set({ "n", "v" }, "<leader>j", vim.cmd.cnext)
