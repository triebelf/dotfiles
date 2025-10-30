-- spellchecker: disable
require("paq")({
    "savq/paq-nvim",
    "https://github.com/miikanissi/modus-themes.nvim.git",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/hedyhli/outline.nvim.git",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    "https://github.com/mhinz/vim-signify",
    "https://github.com/samoshkin/vim-mergetool.git",

    { "https://github.com/nvim-treesitter/nvim-treesitter.git", branch = "main", build = ":TSUpdate" },

    "https://github.com/hrsh7th/nvim-cmp",
    "https://github.com/hrsh7th/cmp-nvim-lsp",
    "https://github.com/dcampos/cmp-snippy",
    "https://github.com/ray-x/cmp-treesitter",
    "https://github.com/hrsh7th/cmp-nvim-lua",
    "https://github.com/hrsh7th/cmp-buffer",
    "https://github.com/dcampos/nvim-snippy",
    "https://github.com/honza/vim-snippets.git",
    "https://github.com/hrsh7th/cmp-path",
    "https://github.com/hrsh7th/cmp-cmdline",

    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/williamboman/mason.nvim.git",
    "https://github.com/williamboman/mason-lspconfig.nvim",
    "https://github.com/p00f/clangd_extensions.nvim.git",

    "https://github.com/mfussenegger/nvim-lint.git",
    "https://github.com/stevearc/conform.nvim.git",
})

vim.o.termguicolors = true
vim.o.background = "light"
require("lualine").setup({ options = { icons_enabled = false } })
require("modus-themes").setup({ style = "auto" })
vim.cmd([[colorscheme modus]])

vim.g.netrw_altv = 1
vim.g.netrw_browse_split = 4
vim.g.netrw_keepdir = 0
vim.g.netrw_list_hide = "__pycache__"
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 20

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.o.cursorline = true
vim.opt.diffopt:append("iwhite")
vim.o.expandtab = true
vim.o.exrc = true
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevelstart = 4
vim.o.foldmethod = "expr"
vim.o.foldtext = ""
vim.o.ignorecase = true
vim.o.mouse = ""
vim.o.number = true
vim.o.shiftround = true
vim.o.shiftwidth = 0
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.opt.inccommand = "split"
vim.o.softtabstop = -1
vim.o.tabstop = 4
vim.o.textwidth = 120
vim.o.undofile = true

vim.filetype.add({
    pattern = {
        [".+cpp.*"] = "cpp",
        [".+hpp.*"] = "cpp",
    },
})

vim.diagnostic.config({ underline = false, signs = false, severity_sort = true, virtual_text = true })

require("outline").setup({
    guides = { enabled = false },
    --outline_window = { width = 20 },
    symbol_folding = { markers = { "▹", "▿" } },
    symbols = {
        icons = {
            Array = { icon = "▦", hl = "Constant" },
            Class = { icon = "⚬", hl = "Type" },
            Constructor = { icon = "⚙", hl = "Special" },
            Enum = { icon = "∑", hl = "Type" },
            EnumMember = { icon = "⋅", hl = "Identifier" },
            Field = { icon = "▪", hl = "Identifier" },
            Function = { icon = "λ", hl = "Function" },
            Method = { icon = "→", hl = "Function" },
            Module = { icon = "⬚", hl = "Include" },
            Namespace = { icon = "∷", hl = "Include" },
            Null = { icon = "␀", hl = "Type" },
            Property = { icon = "▣", hl = "Identifier" },
            String = { icon = "“", hl = "String" },
            Struct = { icon = "⚬", hl = "Structure" },
            TypeAlias = { icon = "≡", hl = "Type" },
            Variable = { icon = "⬞", hl = "Constant" },
        },
    },
})

local parsersInstalled = require("nvim-treesitter.config").get_installed("parsers")
for _, parser in pairs(parsersInstalled) do
    local filetypes = vim.treesitter.language.get_filetypes(parser)
    vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = filetypes,
        callback = function()
            vim.treesitter.start()
        end,
    })
end

require("telescope").setup({
    defaults = {
        layout_config = {
            horizontal = {
                width = { padding = 0 },
                height = { padding = 0 },
                preview_width = 0.5,
            },
        },
        path_display = { "filename_first" },
    },
    pickers = {
        live_grep = {
            additional_args = function(opts)
                return { "--hidden", "--iglob", "!.git" }
            end,
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
    },
})
require("telescope").load_extension("fzf")

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

vim.lsp.config("ltex_plus", {
    settings = {
        ltex = { enabled = true, language = "en-US", additionalRules = { motherTongue = "de-DE" } },
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
        "ltex_plus",
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
vim.keymap.set({ "n", "v" }, "<leader>X", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostic" })
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
