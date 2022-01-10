" persist the undo tree for each file
set undofile

" comma is the leader key
let mapleader=","

" toggle paste mode with <leader>-p
set pastetoggle=<leader>p

" use spaces for tabs
set expandtab

" ignore whitespace in diff
set diffopt+=iwhite

" ignore case when searching
set ignorecase

set wildignore+=.*\.swp$
set wildignore+=.*\.pyc$
set wildignore+=__pycache__
set wildignore+=.pytest_cache/
set wildignore+=.*\.egg-info
set wildignore+=\.venv/

" NERDtree like setup (commands :Ex :Sex :Vex)
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15
let g:netrw_banner = 0
let g:netrw_list_hide = &wildignore
let g:netrw_hide = 1
let g:netrw_keepdir=0

" true color support
set termguicolors
set background=dark
set cursorline

" [plugin] awesome-vim-colorschemes
colorscheme PaperColor

" [plugin] ctrlp.vim
let g:ctrlp_by_filename = 1
let g:ctrlp_max_files = 0
let g:ctrlp_user_command = ['.git/', 'git ls-files -oc --exclude-standard %s']

" [plugin] vim-gutentags
let g:gutentags_cache_dir = $HOME .'/.cache/gutentags'
let g:gutentags_ctags_extra_args = [ '--tag-relative=yes', '--fields=+ailmnS' ]
" let g:gutentags_trace = 1

" [plugin] vim-oscyank
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | OSCYankReg " | endif

set completeopt=menu,menuone,noselect

lua <<EOF
  -- [plugin] nvim-cmp
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        -- [plugin] nvim-snippy
        require('snippy').expand_snippet(args.body)
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources(
      -- [plugin] cmp-nvim-lsp
      { { name = 'nvim_lsp' }, },
      -- [plugin] cmp-buffer
      { { name = 'buffer' }, }
    )
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', { sources = { { name = 'buffer' } } })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources(
      -- [plugin] cmp-path
      { { name = 'path' } },
      -- [plugin] cmp-cmdline
      { { name = 'cmdline' } }
    )
  })

  -- [plugin] nvim-lspconfig
  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', ',g', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', ',D', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', ',t', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', ',i', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', ',r', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', ',d', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', ',D', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', ',n', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', ',wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', ',wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', ',wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', ',c', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', ',e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', ',k', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ',j', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', ',q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    buf_set_keymap('n', ',f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

  -- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches
  local nvim_lsp = require('lspconfig')
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  for _, lsp in ipairs({
      'diagnosticls',
      'dockerls',
      'hls',
      'jsonls',
      'pyright',
      'vimls',
      'yamlls' }) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
      flags = { debounce_text_changes = 150, },
      capabilities = capabilities
    }
  end
EOF
