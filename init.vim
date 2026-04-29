set nocompatible              " be iMproved, required
filetype off                  " required

let mapleader = '\'

"" Plugins"
call plug#begin()
    Plug 'scrooloose/nerdtree'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'ThePrimeagen/harpoon', {'branch': 'harpoon2'}
    Plug 'tpope/vim-surround'
    Plug 'ap/vim-css-color'
    Plug 'pangloss/vim-javascript'
    Plug 'leafgarland/typescript-vim'
    Plug 'peitalin/vim-jsx-typescript'
    Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
    Plug 'jparise/vim-graphql'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.6' }
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'zootedb0t/citruszest.nvim'
    Plug 'mfussenegger/nvim-dap'
    Plug 'madox2/vim-ai'
    Plug 'ojroques/nvim-osc52'
call plug#end()

set autoread
au CursorHold * checktime                                                                                                                                                                       
" Ai
nmap <leader>c :AIChat<CR>
vmap <leader>c :AIChat<CR>

"Nerd Tree"
let g:NERDTreeShowLineNumbers = 1
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

"Airline"
let g:airline_theme='serene'

"Coc"
"Enter to confirm"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

"Tabs to switch"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
set updatetime=300
set signcolumn=yes

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

"Harppon settings"
nnoremap <C-h> <cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>
nnoremap <C-m> <cmd>lua require("harpoon.mark").add_file()<cr>

" Treesitter
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

" Telescope
lua << EOF
local telescope = require('telescope')
local builtin = require('telescope.builtin')
telescope.setup({
  defaults = {
    preview = { treesitter = false },
  },
  extensions = { fzf = {} },
})
telescope.load_extension('fzf')

vim.keymap.set('n', '<leader>ff', builtin.find_files,  { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep,   { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers,     { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags,   { desc = 'Help tags' })
EOF

" Auto-lcd to Git root for project-relative paths (works with Harpoon defaults)
augroup GitRootLcd
  autocmd!
  autocmd VimEnter,BufReadPost,BufWritePost * call s:LcdToGitRoot()
augroup END

function! s:LcdToGitRoot() abort
  if exists('b:git_root_set') | return | endif  " Avoid redundant calls per buffer
  let l:root = system('git rev-parse --show-toplevel 2>/dev/null')
  if v:shell_error == 0 && !empty(l:root)
    let l:root = substitute(l:root, '\n\+$', '', '')  " Trim newline
    if l:root !=# getcwd()  " Only change if different
      execute 'lcd' fnameescape(l:root)
      let b:git_root_set = 1
    endif
  endif
endfunction

syntax on
set showcmd
set encoding=utf-8
set number
set autoindent
set smartindent
set foldmethod=indent
set showmode
set noswapfile
set backupdir=~/.cache/vim
set colorcolumn=79
set backspace=indent,eol,start
set foldnestmax=1


function! ToggleSpellCheck()
  set spell!
  if &spell
    echo "Spellcheck ON"
  else
    echo "Spellcheck OFF"
  endif
endfunction

set nospell
set spelllang=en_ca

" Shared-file clipboard — syncs yanks across SSH sessions on the same machine,
" and also sends to local clipboard via OSC 52
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
  copy  = { ['+'] = copy,  ['*'] = copy },
  paste = { ['+'] = paste, ['*'] = paste },
}
EOF
set clipboard=unnamedplus


set termguicolors
let g:python_highlight_all = 1
set background=dark " or light if you want light mode
colorscheme citruszest

"Spell Check"
nnoremap <silent> <Leader>S :call ToggleSpellCheck()<CR>

"Save file"
nnoremap <c-q> :wq<cr>
nnoremap <c-s> :w<cr>

"control u and d but in the middle"
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

"Folding"
nnoremap <space> za
vnoremap <space> zf

"Comments"
vnoremap <silent> # :s/^/#/<cr>:noh<cr>
vnoremap <silent> -# :s/^#//<cr>:noh<cr>

"Escape File"
imap ` <Esc>
inoremap jh <Esc>

hi Folded ctermbg=black
au BufRead,BufNewFile * match BadWhitespace /\s\+$/

set shiftwidth=4 "Set shift width to 4 spaces."
set tabstop=4 "Set tab width to 4 columns."
set expandtab "Use space characters instead of tabs."


autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" Changes the cursor shape on insert/visual"
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Past without moving
command! -bar -bang -range -register Put call append(<line2> - <bang>0, getreg(<q-reg>, 1, 1))
hi ColorColumn ctermbg=Red
