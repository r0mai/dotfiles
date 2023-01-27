
set nocompatible
filetype off

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'gmarik/Vundle.vim'
Plug 'derekwyatt/vim-fswitch'
Plug 'scrooloose/nerdtree'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-fugitive'
Plug 'r0mai/molokai'
Plug 'Valloric/YouCompleteMe'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-endwise'
Plug 'tomtom/tlib_vim'
Plug 'justinmk/vim-sneak'
" Installed this (also needed for powerlevel9k zsh fonts) https://github.com/ryanoasis/nerd-fonts
Plug 'bling/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'wesQ3/vim-windowswap'
Plug 'vim-scripts/Rename'
Plug 'rking/ag.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'tfnico/vim-gradle'
Plug 'martong/vim-compiledb-path'
Plug 'junegunn/fzf' " https://github.com/junegunn/fzf/blob/master/README-VIM.md
Plug 'tikhomirov/vim-glsl'
Plug 'r0mai/vim-djinni'
Plug 'jeroenbourgois/vim-actionscript'
Plug 'editorconfig/editorconfig-vim'
Plug 'leafgarland/typescript-vim'
Plug 'tpope/vim-surround'
Plug 'lyuts/vim-rtags'
Plug 'leafOfTree/vim-svelte-plugin'

Plug 'tpope/vim-abolish' " Help with camelCasing code

call plug#end()

filetype plugin indent on

set nu

set colorcolumn=81

set hlsearch
set incsearch
set ignorecase

set backspace=indent,eol,start

set history=1000
set autoread
set hidden

" https://unix.stackexchange.com/a/383044
autocmd CursorHold,CursorHoldI,FocusGained,BufEnter * checktime
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

set scrolloff=8
set sidescrolloff=15
set sidescroll=1

set directory=~/.vim/swp//

set mouse=a
if !has('nvim')
  set ttymouse=sgr " http://superuser.com/questions/485956/clicking-far-away-in-vim-in-tmux-in-urxvt
endif

set wildmode=longest,list,full
set wildmenu

set linebreak
set breakindent
set showbreak=↪
set breakat-=-
set breakat-=*
set breakat+=()

function! SetupEnvironment()
  " Default case 4 spaces
  setlocal smartindent
  setlocal softtabstop=4
  setlocal expandtab
  setlocal shiftwidth=4

  let l:path = expand('%:p')
  if l:path =~ 'metashell'
    setlocal expandtab smarttab textwidth=0
    setlocal tabstop=2 shiftwidth=2
  endif
endfunction
autocmd! BufReadPost,BufNewFile * call SetupEnvironment()

" allow toggling between local and default mode
function TabToggle()
  if &expandtab
    setlocal shiftwidth=4
    setlocal softtabstop=0
    setlocal noexpandtab
  else
    setlocal shiftwidth=4
    setlocal softtabstop=4
    setlocal expandtab
  endif
endfunction
nmap <F9> mz:execute TabToggle()<CR>'z

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

" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.swf let &bin=1
  au BufReadPost *.swf if &bin | %!xxd
  au BufReadPost *.swf set ft=xxd | endif
  au BufWritePre *.swf if &bin | %!xxd -r
  au BufWritePre *.swf endif
  au BufWritePost *.swf if &bin | %!xxd
  au BufWritePost *.swf set nomod | endif
augroup END

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

  command! -bang Tc tabclose<bang>
  command! -bang TC tabclose<bang>
  "TODO X is reserved for encryption
  command! -bang Xa xa<bang>
  command! -bang XA xa<bang>
  command! -nargs=? -complete=file Vn vert new <args>
  command! -nargs=? -complete=file VN vert new <args>
  command! -nargs=? -complete=file Hn new <args>
  command! -nargs=? -complete=file HN new <args>
  command! -nargs=? -complete=file Te tabedit <args>
  command! -nargs=? -complete=file TE tabedit <args>

  "vim-fswitch
  command! A :FSHere
  command! Av :FSSplitRight
  command! AV :FSSplitRight
endif

command Bc execute "bufdo checktime"
command BC execute "bufdo checktime"

"duplicate current windows horizontally/vertically
map <leader>dwh :Hn %<CR>
map <leader>dwv :Vn %<CR>

"saving
map <leader>w :wa<CR>
map <leader>x :x<CR>
map <leader>e :e<CR>

"quiting
map <leader>q :q<CR>

nmap <c-p> :FZF<CR>

"NERDTree
map <Leader>n <plug>NERDTreeMirrorToggle<CR>
let NERDTreeIgnore = ['\.pyc$', '\.o$']

"taglist
let Tlist_Use_Right_Window = 1
map <Leader>tl :TlistToggle<CR>

"YouCompleteMe Config
" let g:loaded_youcompleteme = 1 " disables ycm
let g:ycm_goto_buffer_command = 'split'
map <Leader>gd :YcmCompleter GoTo<CR>
map <Leader>gt :tab YcmCompleter GoTo<CR>
map <Leader>gv :rightbelow vertical YcmCompleter GoTo<CR>
map <Leader>gi :YcmCompleter GoToImprecise<CR>
 " Show documentation popup
nmap <leader>D <plug>(YCMHover)
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_confirm_extra_conf = 0
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_auto_hover = -1 " this turns off auto hover pop-ups (<leader>D still works)
set completeopt-=preview " this turns off YCM opening a small window after every TAB https://github.com/ycm-core/YouCompleteMe/issues/2015

" settings from https://clang.llvm.org/extra/clangd/Installation.html
let g:ycm_clangd_uses_ycmd_caching = 0
let g:ycm_clangd_binary_path = '/usr/local/opt/llvm/bin/clangd' " install with brew install llvm
let g:ycm_clangd_args=['--header-insertion=never']

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

"EditorConfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let g:EditorConfig_exec_path = '/usr/local/bin/editorconfig'

"TypeScript filetype detection
autocmd BufNewFile,BufRead *.ts set syntax=typescript

"ClangFormat
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>

"vim-compiledb-path
autocmd VimEnter CompileDbPathIfExists 'bin/compile_commands.json'
autocmd VimEnter CompileDbPathIfExists 'build/osx-x64-ninja-debug/ninja/compile_commands.json'
autocmd VimEnter CompileDbPathIfExists 'build/compile_commands.json'

" highlight vs fs with vim-glsl
autocmd! BufNewFile,BufRead *.vs,*.fs set ft=glsl

" format XML
function! FormatXMLFunc()
  silent %!xmllint --format --encode UTF-8 --recover - 2>/dev/null
endfunction

command! FormatXML call FormatXMLFunc()

"airline
let g:airline_powerline_fonts = 1

"vim-session
let g:session_autosave = 'no'
let g:session_autoload = 'no'

set t_Co=256
let g:rehash256 = 1
syntax on
set synmaxcol=0
set laststatus=2

set splitbelow
set splitright

set background=dark
let g:solarized_termcolors=256
colorscheme molokai
"colorscheme solarized

"If the console is narrow, then I'm probably on a projector =>
"switch to light colorscheme
"if &columns < 150
"  set background=light
"endif
