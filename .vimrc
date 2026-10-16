" vimrc for terminal Vim 8.2 (patches 1-2637)
" Install as ~/.vimrc

" ---------------------------------------------------------------------------
" General behaviour
" ---------------------------------------------------------------------------
set nocompatible
filetype plugin indent on
syntax enable

set encoding=utf-8
set hidden                    " Allow switching away from modified buffers
set autoread                  " Reload files changed outside Vim
set confirm                   " Ask before abandoning unsaved changes
set mouse=a
set backspace=indent,eol,start
set history=1000
set updatetime=300
set timeoutlen=500

" ---------------------------------------------------------------------------
" Appearance (change 'dark' to 'light' for a light terminal)
" ---------------------------------------------------------------------------
set background=dark
if has('termguicolors')
  set termguicolors
endif
colorscheme desert

set number
set relativenumber
set cursorline
set ruler
set showcmd
set showmode
set laststatus=2
set signcolumn=yes
set colorcolumn=80
set scrolloff=5
set sidescrolloff=5
set nowrap
set list
set listchars=tab:>-,trail:·,extends:>,precedes:<,nbsp:+
set wildmenu
set wildmode=longest:full,full
set wildignore+=*.o,*.obj,*.so,*.a,*.pyc,__pycache__,.git

" Compact built-in status line; no plugin required.
set statusline=%f%m%r%h%w\ [%{&filetype}]\ [%{&fileencoding!=''?&fileencoding:&encoding}]
set statusline+=%=%l:%c\ %p%%

" ---------------------------------------------------------------------------
" Indentation: spaces everywhere, except Makefiles
" ---------------------------------------------------------------------------
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set autoindent
set smartindent

augroup indentation
  autocmd!
  " make requires literal tab characters at the start of recipe lines.
  autocmd FileType make setlocal noexpandtab tabstop=8 softtabstop=0 shiftwidth=8
augroup END

" ---------------------------------------------------------------------------
" C, C++, MPI and CUDA
" ---------------------------------------------------------------------------
augroup scientific_languages
  autocmd!
  autocmd BufNewFile,BufRead *.cu,*.cuh setfiletype cuda
  autocmd FileType c,cpp,cuda setlocal cindent commentstring=//\ %s
  autocmd FileType c,cpp,cuda setlocal path+=/usr/include,/usr/local/include

  " MPI is a library API rather than a separate language. Highlight common
  " MPI types, constants and functions on top of normal C/C++ highlighting.
  autocmd FileType c,cpp,cuda syntax keyword mpiType MPI_Comm MPI_Datatype MPI_Request MPI_Status MPI_Op MPI_Group MPI_Win MPI_File MPI_Info MPI_Message
  autocmd FileType c,cpp,cuda syntax keyword mpiConstant MPI_COMM_WORLD MPI_COMM_SELF MPI_COMM_NULL MPI_ANY_SOURCE MPI_ANY_TAG MPI_PROC_NULL MPI_SUCCESS MPI_STATUS_IGNORE MPI_STATUSES_IGNORE MPI_IN_PLACE
  autocmd FileType c,cpp,cuda syntax match mpiFunction /\<MPI_[A-Za-z0-9_]\+\>/
  autocmd FileType c,cpp,cuda highlight default link mpiType Type
  autocmd FileType c,cpp,cuda highlight default link mpiConstant Constant
  autocmd FileType c,cpp,cuda highlight default link mpiFunction Function

  " Extra CUDA constructs, useful if the installed runtime has limited CUDA
  " syntax definitions.
  autocmd FileType cuda syntax keyword cudaQualifier __global__ __device__ __host__ __shared__ __constant__ __managed__ __restrict__
  autocmd FileType cuda syntax keyword cudaBuiltin threadIdx blockIdx blockDim gridDim warpSize
  autocmd FileType cuda highlight default link cudaQualifier StorageClass
  autocmd FileType cuda highlight default link cudaBuiltin Identifier
augroup END

" ---------------------------------------------------------------------------
" Search and editing safety
" ---------------------------------------------------------------------------
set ignorecase
set smartcase
set incsearch
set hlsearch
set magic
set showmatch

set undofile
set undolevels=1000
if !isdirectory(expand('~/.vim/undo'))
  call mkdir(expand('~/.vim/undo'), 'p', 0700)
endif
set undodir=~/.vim/undo//

set backup
set writebackup
if !isdirectory(expand('~/.vim/backup'))
  call mkdir(expand('~/.vim/backup'), 'p', 0700)
endif
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
if !isdirectory(expand('~/.vim/swap'))
  call mkdir(expand('~/.vim/swap'), 'p', 0700)
endif

" ---------------------------------------------------------------------------
" Convenient mappings (leader is Space)
" ---------------------------------------------------------------------------
let mapleader=' '
nnoremap <leader>w :write<CR>
nnoremap <leader>q :quit<CR>
nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>n :set number! relativenumber!<CR>
nnoremap <leader>l :set list!<CR>
nnoremap <leader>e :Explore<CR>

" Keep selected text selected while shifting it.
vnoremap < <gv
vnoremap > >gv

" Move naturally through wrapped screen lines.
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" Remove trailing whitespace without moving the cursor: <Space>t
function! StripTrailingWhitespace() abort
  let l:view = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:view)
endfunction
nnoremap <leader>t :call StripTrailingWhitespace()<CR>

" Use :make and navigate errors with :cnext / :cprevious.
nnoremap <leader>m :make<CR>
nnoremap ]q :cnext<CR>
nnoremap [q :cprevious<CR>
