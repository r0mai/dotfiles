
set nocompatible
filetype off

if !isdirectory(expand("~/.vim/bundle/Vundle.vim/.git"))
  !git clone git@github.com:gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
endif

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

let g:vundle_default_git_proto = 'git'

Plugin 'a.vim'
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-scripts/taglist.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-fugitive'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'r0mai/molokai'
Plugin 'kana/vim-operator-user'
Plugin 'Valloric/YouCompleteMe.git'
Plugin 'tomtom/tcomment_vim.git'
Plugin 'vim-scripts/SearchComplete.git'
Plugin 'tpope/vim-endwise.git'
Plugin 'tomtom/tlib_vim.git'
Plugin 'MarcWeber/vim-addon-mw-utils.git'
Plugin 'xolox/vim-session.git'
Plugin 'xolox/vim-misc.git'
Plugin 'justinmk/vim-sneak.git'
Plugin 'vim-scripts/YankRing.vim.git'
Plugin 'ntpeters/vim-better-whitespace.git'
Plugin 'bling/vim-airline.git'
Plugin 'airblade/vim-gitgutter.git'
Plugin 'wesQ3/vim-windowswap'
Plugin 'vim-scripts/Rename'
Plugin 'tpope/vim-sleuth'
Plugin 'rking/ag.vim'
Plugin 'sjl/gundo.vim'
Plugin 'BufOnly.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'tfnico/vim-gradle'
Plugin 'vim-jp/cpp-vim'
Plugin 'martong/vim-compiledb-path'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'jdonaldson/vaxe'
Plugin 'lyuts/vim-rtags'

call vundle#end()
filetype plugin indent on

set nu

set smartindent
set tabstop=4
set expandtab
set shiftwidth=4
set colorcolumn=80

set hlsearch
set incsearch

set backspace=indent,eol,start

set history=1000
set autoread
set hidden

set scrolloff=8
set sidescrolloff=15
set sidescroll=1

set directory=~/.vim/swp//

set mouse=a

set wildmode=longest,list,full
set wildmenu

set linebreak
set breakindent
set showbreak=↪
set breakat-=-
set breakat-=*
set breakat+=()

function! SetupEnvironment()
  let l:path = expand('%:p')
  if l:path =~ 'metashell'
    setlocal expandtab smarttab textwidth=0
    setlocal tabstop=2 shiftwidth=2
  elseif l:path =~ 'prezi'
    setlocal noexpandtab smarttab textwidth=0
    setlocal tabstop=4 shiftwidth=4
  endif
endfunction
autocmd! BufReadPost,BufNewFile * call SetupEnvironment()

nnoremap <S-l> gt
nnoremap <S-h> gT

noremap <silent> <C-S> :wa<CR>
vnoremap <silent> <C-S> <C-C>:wa<CR>
inoremap <silent> <C-S> <C-O>:wa<CR>

nnoremap <Leader>/ :let @/ = ""<return>

nnoremap <F6> :GundoToggle<CR>

"delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d

if has('persistent_undo')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

"aliases for common command typos
"(idea from http://blog.sanctum.geek.nz/vim-command-typos/)
if has("user_commands")
  command! -bang -nargs=? -complete=file W w<bang> <args>
  command! -bang -nargs=? -complete=file Wq wq<bang> <args>
  command! -bang -nargs=? -complete=file WQ wq<bang> <args>
  command! -bang Wa wa<bang>
  command! -bang WA wa<bang>
  command! -bang Q q<bang>
  command! -bang Qa qa<bang>
  command! -bang QA qa<bang>
  "TODO X is reserved for encryption
  command! -bang Xa xa<bang>
  command! -bang XA xa<bang>
  command! -nargs=? -complete=file Vn vert new <args>
  command! -nargs=? -complete=file VN vert new <args>
  command! -nargs=? -complete=file Hn new <args>
  command! -nargs=? -complete=file HN new <args>
  command! -nargs=? -complete=file Te tabedit <args>
  command! -nargs=? -complete=file TE tabedit <args>
endif

command Bc execute "bufdo checktime"
command BC execute "bufdo checktime"

"duplicate current windows horizontally/vertically
map <leader>dwh :Hn %<CR>
map <leader>dwv :Vn %<CR>

"saving
map <leader>s :wa<CR>

"CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

"NERDTree
map <Leader>n <plug>NERDTreeMirrorToggle<CR>
let NERDTreeIgnore = ['\.pyc$', '\.o$']

"taglist
let Tlist_Use_Right_Window = 1
map <Leader>tl :TlistToggle<CR>

"YouCompleteMe Config
map gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
map gi :YcmCompleter GoToImprecise<CR>
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_confirm_extra_conf = 0
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_semantic_triggers = {
  \ 'c' : ['->', '.'],
  \ 'cpp,objcpp' : ['->', '.', '::'],
  \ 'perl' : ['->'],
  \ 'php' : ['->', '::'],
  \ 'cs,java,javascript,d,vim,ruby,python,perl6,scala,vb,elixir,go' : ['.'],
  \ 'lua' : ['.', ':'],
  \ 'erlang' : [':'],
  \ }

let g:clang_format#style_options = {
  \ "AccessModifierOffset" : -4,
  \ "AllowShortIfStatementsOnASingleLine" : "true",
  \ "AlwaysBreakTemplateDeclarations" : "true",
  \ "TabWidth" : 4,
  \ "UseTab" : "Always",
  \ "ColumnLimit" : 0,
  \ "Standard" : "C++11",
  \ "BreakBeforeBraces" : "Attach"}

"ClangFormat
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>

"vim-compiledb-path
autocmd VimEnter CompileDbPathIfExists 'build/osx_x64_debug/make/compile_commands.json'
autocmd VimEnter CompileDbPathIfExists 'bin/compile_commands.json'
autocmd VimEnter CompileDbPathIfExists 'build/osx_x64_debug/ninja/compile_commands.json'

"airline
let g:airline_powerline_fonts = 1

"vim-session
let g:session_autosave = 'no'

set t_Co=256
let g:rehash256 = 1
syntax on
set synmaxcol=0
set laststatus=2

set background=dark
let g:solarized_termcolors=256
colorscheme molokai

"If the console is narrow, then I'm probably on a projector =>
"switch to light colorscheme
if &columns < 150
  set background=light
endif
