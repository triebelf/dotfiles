-- spellchecker: disable
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"

-- Bootstrap Paq if missing
if fn.empty(fn.glob(install_path)) > 0 then
    print("Bootstrapping Paq...")
    fn.system({ "git", "clone", "https://github.com/savq/paq-nvim.git", install_path })
end

-- Load Paq
vim.cmd("packadd paq-nvim")
local paq = require("paq")

-- Define plugins
local plugins = {
    "savq/paq-nvim", -- Paq manages itself
    "miikanissi/modus-themes.nvim",
    "nvim-lualine/lualine.nvim",
    "hedyhli/outline.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim",

    "mhinz/vim-signify",
    "samoshkin/vim-mergetool",

    { "nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate" },

    "saghen/blink.cmp",
    "saghen/blink.lib",
    "rafamadriz/friendly-snippets",

    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "p00f/clangd_extensions.nvim",

    "mfussenegger/nvim-lint",
    "stevearc/conform.nvim",

    "zbirenbaum/copilot.lua",
    "olimorris/codecompanion.nvim",
    -- "ravitemer/mcphub.nvim",
}

-- Register plugins with Paq
paq(plugins)

-- Auto-install missing plugins
local missing = false
for _, plugin in ipairs(plugins) do
    -- Determine plugin name
    local name
    if type(plugin) == "string" then
        name = plugin:match(".*/(.*)")
    elseif type(plugin) == "table" and type(plugin[1]) == "string" then
        name = plugin[1]:match(".*/(.*)")
    end

    -- Skip if we couldn't determine a name
    if name then
        local plugin_path = fn.stdpath("data") .. "/site/pack/paqs/start/" .. name
        if fn.empty(fn.glob(plugin_path)) > 0 then
            missing = true
            break
        end
    end
end

if missing then
    print("Installing missing plugins...")
    paq.install()
    print("Plugins installed. Please restart Neovim.")
    return
end

vim.o.termguicolors = true
require("modus-themes").setup({ style = "auto", variants = { modus_vivendi = "tinted" } })
vim.cmd("colorscheme modus")

require("lualine").setup({ options = { theme = "auto" } })

vim.g.netrw_altv = 1
vim.g.netrw_browse_split = 4
vim.g.netrw_keepdir = 0
vim.g.netrw_list_hide = "__pycache__"
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 20

vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect", "popup" }
vim.opt.diffopt:append("iwhite")
vim.o.expandtab = true
vim.o.exrc = true
vim.o.foldlevelstart = 4
vim.o.foldtext = ""
vim.o.linebreak = true
vim.o.ignorecase = true
vim.o.mouse = ""
--vim.o.number = true
vim.o.shiftround = true
vim.o.shiftwidth = 0
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.opt.inccommand = "split"
vim.o.softtabstop = -1
vim.o.tabstop = 4
vim.o.textwidth = 120
vim.o.undofile = true

vim.api.nvim_create_autocmd("FileType", {
    pattern = "diff",
    callback = function()
        vim.opt_local.expandtab = false
    end,
})

vim.filetype.add({
    pattern = {
        [".+cpp.*"] = "cpp",
        [".+hpp.*"] = "cpp",
    },
})

vim.diagnostic.config({ underline = false, signs = false, severity_sort = true, virtual_text = true })

require("copilot").setup({})

local cc_defaults = require("codecompanion.config")
local default_agent_prompt = cc_defaults.interactions.chat.tools.groups["agent"].system_prompt
local default_tool_prompt = cc_defaults.interactions.chat.tools.opts.system_prompt.prompt
local terse = [[
Be extremely terse.
Respond with code only; omit prose and explanation unless explicitly asked.
Never write comments in code.
Write any non-code text in grug-brain caveman speak: short sentences, simple words, drop articles.
]]

require("codecompanion").setup({
    adapters = { copilot = { model = "Auto" } },
    rules = { opts = { chat = { autoload = "default", enabled = true } } },
    display = { chat = { fold_reasoning = false, show_reasoning = false } },
    interactions = {
        chat = {
            adapter = "copilot",
            -- adapter = { name = "ollama", model = "gemma4:12b" },
            opts = {
                context_management = {
                    compaction = { trigger = 0.7, min_token_savings = 5000 },
                },
                system_prompt = function(ctx)
                    local prompt = string.gsub(ctx.default_system_prompt, "All non-code text.+language.", terse)
                    return prompt .. "\n\n" .. terse
                end,
            },
            tools = {
                groups = {
                    ["agent"] = {
                        system_prompt = function(group, ctx)
                            return (
                                string.gsub(default_agent_prompt(group, ctx), "All non-code text.+language.", terse)
                            )
                        end,
                    },
                },
                opts = {
                    system_prompt = {
                        prompt = function(args)
                            return (
                                string.gsub(
                                    default_tool_prompt(args),
                                    "Use proper Markdown formatting in your answers.",
                                    terse
                                )
                            )
                        end,
                    },
                },
                -- Never prompt for read-only tools
                read_file = { opts = { require_approval_before = false } },
                grep_search = { opts = { require_approval_before = false } },
                file_search = { opts = { require_approval_before = false } },
                get_changed_files = { opts = { require_approval_before = false } },
                get_diagnostics = { opts = { require_approval_before = false } },
                fetch_webpage = { opts = { require_approval_before = false } },
                -- auto-approve all shell commands in YOLO mode:
                run_command = { opts = { allowed_in_yolo_mode = true } },
            },
        },
    },
    -- extensions = {
    --     mcphub = {
    --         callback = "mcphub.extensions.codecompanion",
    --         opts = {
    --             make_tools = true,
    --             make_vars = false,
    --         },
    --     },
    -- },
})
-- require("mcphub").setup()

require("blink.cmp").setup({
    completion = {
        menu = { auto_show = false },
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
    },
    cmdline = { completion = { menu = { auto_show = false } } },
    keymap = { preset = "enter" },
})

require("outline").setup({
    guides = { enabled = false },
    symbols = {
        icons = {
            Array = { icon = "▦", hl = "Constant" },
            Class = { icon = "󱡠", hl = "Type" },
            Constructor = { icon = "󰒓", hl = "Special" },
            Enum = { icon = "󰦨", hl = "Type" },
            EnumMember = { icon = "󰦨", hl = "Identifier" },
            Field = { icon = "󰜢", hl = "Identifier" },
            Function = { icon = "󰊕", hl = "Function" },
            Method = { icon = "󰊕", hl = "Function" },
            Module = { icon = "󰅩", hl = "Include" },
            Namespace = { icon = "∷", hl = "Include" },
            Null = { icon = "␀", hl = "Type" },
            Property = { icon = "󰖷", hl = "Identifier" },
            String = { icon = "󰉿", hl = "String" },
            Struct = { icon = "󱡠", hl = "Structure" },
            Variable = { icon = "󰆦", hl = "Constant" },
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
            vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo[0][0].foldmethod = "expr"
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
        ["ui-select"] = {
            require("telescope.themes").get_dropdown({ layout_config = { width = 0.8 } }),
        },
    },
})
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")

-- LSPs configuration

vim.lsp.log.set_level("off")

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
            workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false, preloadFileSize = 10000 },
            telemetry = { enable = false },
        },
    },
})

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "bashls",
        "clangd",
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
        bzl = { "buildifier" },
        cpp = { "clang_format" },
        json = { "jq" },
        lua = { "stylua" },
        python = { "isort", "black" },
        sh = { "shellcheck", "shellharden" },
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
vim.keymap.set({ "n", "v" }, "<leader>l", ":set nu!<CR>")
vim.keymap.set({ "n", "v" }, "<leader>c", "<cmd>CodeCompanionChat Toggle<cr>")
vim.keymap.set({ "n", "v" }, "<leader>w", vim.cmd.OutlineFocus)
vim.keymap.set({ "n", "v" }, "<leader>k", vim.cmd.cprev)
vim.keymap.set({ "n", "v" }, "<leader>h", vim.cmd.ClangdSwitchSourceHeader)

vim.keymap.set({ "n", "v" }, "<leader>g", tele.lsp_definitions)
-- "grt" is mapped to vim.lsp.buf.type_definition()

vim.keymap.set({ "n", "v" }, "<leader>f", require("conform").format)
vim.keymap.set({ "n", "v" }, "<leader>q", tele.builtin)
vim.keymap.set({ "n", "v" }, "<leader>u", tele.resume)

vim.keymap.set({ "n", "v" }, "<leader>i", tele.lsp_implementations)
-- "gri" is mapped to vim.lsp.buf.implementation()

--vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action)
-- "gra" (Normal and Visual mode) is mapped to vim.lsp.buf.code_action()

vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>CodeCompanionActions<cr>")
vim.keymap.set({ "n", "v" }, "<leader>e", vim.diagnostic.open_float) -- Ctrl-W d
vim.keymap.set({ "n", "v" }, "<leader>o", tele.git_files)
vim.keymap.set({ "n", "v" }, "<leader>s", tele.lsp_dynamic_workspace_symbols)

-- vim.keymap.set({ "n", "v" }, "<leader>n", vim.lsp.buf.rename)
-- "grn" is mapped to vim.lsp.buf.rename()

vim.keymap.set({ "n", "v" }, "<leader>r", tele.lsp_references)
-- "grr" is mapped to vim.lsp.buf.references()

vim.keymap.set({ "n", "v" }, "<leader>t", vim.cmd.ClangdTypeHierarchy) -- use "gd" to jump to entry

-- vim.keymap.set({ "n", "v" }, "<leader>d", vim.lsp.buf.hover)
-- K
-- "gO" is mapped to vim.lsp.buf.document_symbol()
-- CTRL-S (Insert mode) is mapped to vim.lsp.buf.signature_help()

vim.keymap.set({ "n", "v" }, "<leader>y", tele.registers)
vim.keymap.set({ "n", "v" }, "<leader>p", tele.lsp_incoming_calls)
vim.keymap.set({ "n", "v" }, "<leader>z", tele.find_files)
vim.keymap.set({ "n", "v" }, "<leader>b", tele.buffers)
vim.keymap.set({ "n", "v" }, "<leader>m", tele.oldfiles)
vim.keymap.set({ "n", "v" }, "<leader>,", tele.live_grep)
vim.keymap.set({ "n", "v" }, "<leader>.", tele.grep_string)
vim.keymap.set({ "n", "v" }, "<leader>j", vim.cmd.cnext)

-- "grx" is mapped to vim.lsp.codelens.run()
