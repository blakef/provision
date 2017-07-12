call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'gregsexton/gitv'
Plug 'Xuyuanp/nerdtree-git-plugin'
" Efficiency
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/vim-easy-align'
Plug 'majutsushi/tagbar'
" Linting
Plug 'w0rp/ale'
" GoLang
Plug 'sebdah/vim-delve'
Plug 'fatih/vim-go'
Plug 'jstemmer/gotags'
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
" TypeScript
Plug 'Quramy/tsuquyomi'
" HTML
Plug 'mattn/emmet-vim'

" Theme
Plug 'NLKNguyen/papercolor-theme'

call plug#end()

let &runtimepath.=',~/.vim/bundle/ale'

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

"GoLang

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1

let g:go_fmt_command = "goimports"

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

" Go: Docs and Defs
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)

" Go: Info under curosr
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>i <Plug>(go-info)

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

" Nerdtree
noremap <c-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" Misc 
let mapleader=","
set number

set colorcolumn=120

nnoremap <F8> :TagbarToggle<CR>

" Colour Scheme
set background=dark
colorscheme PaperColor
highlight Search guibg=DeepPink4 guifg=White ctermbg=53 ctermfg=White

if has("gui_running")
  highlight ColourColumn guibg=darkgray
else
  highlight ColourColumn ctermbg=darkgray
endif

" Use <leader>l to toggle display of whitespace
nnoremap <leader>l :set list!<CR>
set listchars=tab:»\ ,eol:¬

" ctrlp
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" Misc code formatting
syntax on

set tabstop=4
set shiftwidth=4
set expandtab

set backspace=indent,eol,start
" Auto open fold on open
set foldmethod=indent
set autoindent
if has("autocmd")
    autocmd BufWinEnter * silent! :%foldopen!
endif
set nowrap

" Ale
silent! helptags ALL
let g:ale_sign_error = '⤫'
highlight clear ALEErrorSign
let g:ale_sign_warning = '⚠'
highlight clear ALEWarningSign
let g:airline#extensions#ale#enabled = 1

" 
" Lets get more efficient
"
inoremap jk <Esc>
inoremap kj <Esc>wa
