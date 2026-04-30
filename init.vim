set nocompatible
filetype off

let mapleader = '\'

" ── Plugins ───────────────────────────────────────────────────────────────────
call plug#begin()
    " UI
    Plug 'scrooloose/nerdtree'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'zootedb0t/citruszest.nvim'

    " LSP / completion
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " Navigation
    Plug 'ThePrimeagen/harpoon', {'branch': 'harpoon2'}
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.6' }
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

    " Syntax / language
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'pangloss/vim-javascript'
    Plug 'leafgarland/typescript-vim'
    Plug 'peitalin/vim-jsx-typescript'
    Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
    Plug 'jparise/vim-graphql'
    Plug 'ap/vim-css-color'

    " Editing
    Plug 'tpope/vim-surround'
    Plug 'madox2/vim-ai'

    " Clipboard
    Plug 'ojroques/nvim-osc52'

    " Debugging
    Plug 'mfussenegger/nvim-dap'
call plug#end()

" ── General settings ──────────────────────────────────────────────────────────
syntax on
set encoding=utf-8
set number
set showcmd
set showmode
set autoread
set noswapfile
set backupdir=~/.cache/vim
set backspace=indent,eol,start
set signcolumn=yes
set updatetime=300          " faster CursorHold for coc diagnostics
set colorcolumn=79
set termguicolors
set background=dark
colorscheme citruszest

" auto-reload files changed outside vim
au CursorHold * checktime

" ── Indentation ───────────────────────────────────────────────────────────────
set autoindent
set smartindent
set shiftwidth=4
set tabstop=4
set expandtab

" ── Folding ───────────────────────────────────────────────────────────────────
set foldmethod=indent
set foldnestmax=1
hi Folded ctermbg=black

" ── Spell check ───────────────────────────────────────────────────────────────
set nospell
set spelllang=en_ca

function! ToggleSpellCheck()
  set spell!
  echo &spell ? "Spellcheck ON" : "Spellcheck OFF"
endfunction

" ── Keymaps ───────────────────────────────────────────────────────────────────
" Save / quit
nnoremap <c-s> :w<cr>
nnoremap <c-q> :wq<cr>

" Escape from insert mode
imap ` <Esc>
inoremap jh <Esc>

" Keep cursor centered when scrolling
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

" Folding
nnoremap <space> za
vnoremap <space> zf

" Toggle comment on selected lines
vnoremap <silent> # :s/^/#/<cr>:noh<cr>
vnoremap <silent> -# :s/^#//<cr>:noh<cr>

" Spell check toggle
nnoremap <silent> <Leader>S :call ToggleSpellCheck()<CR>

" Paste without moving cursor
command! -bar -bang -range -register Put call append(<line2> - <bang>0, getreg(<q-reg>, 1, 1))

" Cursor shape: beam in insert, block in normal
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" ── NERDTree ──────────────────────────────────────────────────────────────────
let g:NERDTreeShowLineNumbers = 1
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
" close vim if NERDTree is the last open window
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" ── Airline ───────────────────────────────────────────────────────────────────
let g:airline_theme='serene'

" ── CoC ───────────────────────────────────────────────────────────────────────
" Enter confirms completion, Tab/S-Tab cycle candidates
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" K shows hover docs; falls back to built-in K if no hover provider
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
nnoremap <silent> K :call ShowDocumentation()<CR>

" ── Harpoon ───────────────────────────────────────────────────────────────────
nnoremap <C-h> <cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>
nnoremap <C-m> <cmd>lua require("harpoon.mark").add_file()<cr>

" ── vim-ai ────────────────────────────────────────────────────────────────────
nmap <leader>c :AIChat<CR>
vmap <leader>c :AIChat<CR>

" ── Treesitter ────────────────────────────────────────────────────────────────
lua << EOF
local ok, ts = pcall(require, 'nvim-treesitter')
if ok then
  ts.setup {
    ensure_installed = {
      'javascript', 'typescript', 'tsx',
      'python', 'graphql', 'css',
      'lua', 'vim', 'bash', 'markdown',
    },
  }
end
EOF

" ── Telescope ─────────────────────────────────────────────────────────────────
lua << EOF
local telescope = require('telescope')
local builtin   = require('telescope.builtin')
telescope.setup({
  defaults = {
    preview = { treesitter = false },
  },
  extensions = { fzf = {} },
})
telescope.load_extension('fzf')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep,  { desc = 'Live grep'  })
vim.keymap.set('n', '<leader>fb', builtin.buffers,    { desc = 'Buffers'    })
vim.keymap.set('n', '<leader>fh', builtin.help_tags,  { desc = 'Help tags'  })
EOF

" ── Clipboard ─────────────────────────────────────────────────────────────────
" Syncs yanks to ~/.nvim_clipboard so they survive SSH sessions,
" and forwards to the terminal's local clipboard via OSC 52.
lua << EOF
local clip_file = vim.fn.expand('~/.nvim_clipboard')
local ok, osc52 = pcall(require, 'osc52')
if ok then
  osc52.setup { max_length = 0, silent = true, trim = false }
end

local function copy(lines, _)
  local text = table.concat(lines, '\n')
  local f = io.open(clip_file, 'w')
  if f then f:write(text); f:close() end
  if ok then osc52.copy(text) end
end

local function paste()
  local f = io.open(clip_file, 'r')
  if f then
    local text = f:read('*a')
    f:close()
    return { vim.fn.split(text, '\n'), 'v' }
  end
  return { {}, 'v' }
end

vim.g.clipboard = {
  name  = 'shared-file',
  copy  = { ['+'] = copy,  ['*'] = copy  },
  paste = { ['+'] = paste, ['*'] = paste },
}
EOF
set clipboard=unnamedplus

" ── Git root lcd ──────────────────────────────────────────────────────────────
" lcd to the git root on open/save so Harpoon marks use project-relative paths
augroup GitRootLcd
  autocmd!
  autocmd VimEnter,BufReadPost,BufWritePost * call s:LcdToGitRoot()
augroup END

function! s:LcdToGitRoot() abort
  if exists('b:git_root_set') | return | endif
  let l:root = system('git rev-parse --show-toplevel 2>/dev/null')
  if v:shell_error == 0 && !empty(l:root)
    let l:root = substitute(l:root, '\n\+$', '', '')
    if l:root !=# getcwd()
      execute 'lcd' fnameescape(l:root)
      let b:git_root_set = 1
    endif
  endif
endfunction

" ── Misc ──────────────────────────────────────────────────────────────────────
let g:python_highlight_all = 1
hi ColorColumn ctermbg=Red

" flag trailing whitespace in all files
au BufRead,BufNewFile * match BadWhitespace /\s\+$/

" re-sync JS/TS syntax on enter (large files can desync)
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
