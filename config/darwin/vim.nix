{ config, pkgs, ... }: {

  programs.vim = {

    enable = true;

    enableSensible = true;

    plugins = [
      {
        names = [
          "colors-solarized"
          "commentary"
          "ctrlp"
          "fugitive"
          "gist-vim"
          "multiple-cursors"
          "nerdcommenter"
          "nerdtree"
          "polyglot"
          "repeat"
          "surround"
          "syntastic"
          "undotree"
          "vim-airline"
          "vim-airline-themes"
          "vim-gitgutter"
          "vim-nerdtree-tabs"
          "vim-signify"
          "webapi-vim"
        ];
      }
    ];

    vimConfig = ''
      " Environment {
          set nocompatible
      " }

      " General settings {
          filetype plugin indent on         " automatically detect file types
          syntax on                         " syntax highlighting
          set mouse=a                       " automatically enable mouse usage
          set mousehide                     " hide mouse cursor when typing

          set encoding=utf-8
          scriptencoding utf-8
          set termencoding=utf-8

          " Better unix compatibility
          set viewoptions=folds,options,cursor,unix,slash

          set shortmess+=filmnrxoOtT        " message abbreviation
          set virtualedit=onemore           " cursor can go one beyond last char
          set history=1000                  " store a lot of history

          set clipboard=unnamed             " share clipboard with the OS

          " Backup and undo
          set backup                        " backups are nice ...
          if has('persistent_undo')
            set undofile                    " so is persistent_undo
            set undolevels=1000             " max changes that can be undone
            set undoreload=10000            " max lines to save for undo on reload
          endif
          set hidden                        " allow buffer switching without saving

          " Modeline
          set modeline                      " last lines in document sets vim mode
          set modelines=3                   " number of lines checked for modelines

          if has("autocmd")
            au bufwinleave * silent! mkview   " make vim save view(state) (folds, cursor, etc)
            au bufwinenter * silent! loadview " make vim load view(state) (folds, cursor, etc)

            " switch to the current file directory
            au bufenter * if bufname("") !~ "^\[a-za-z0-9\]*://" | lcd %:p:h | endif

            " instead of reverting the cursor to the last position in the buffer, we
            " set it to the first line when editing a git commit message
            au filetype gitcommit au! bufenter commit_editmsg call setpos('.', [0, 1, 1, 0])

            " restore cursor position
            au bufreadpost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
          endif
      " }

      " ui {
          " font {
              set guifont=menlo\ for\ powerline
          "
          " colorscheme {
              set background=dark                 " set a default dark background
              let g:solarized_contrast="high"
              let g:solarized_visibility="high"
              color solarized                     " load colorscheme
          " }

          " general ui settings {
              set tabpagemax=15                   " only show 15 tabs
              set showmode                        " display the current mode
              set title                           " show the filename in the window titlebar
              set cursorline                      " highlight current line
              highlight clear signcolumn          " signcolumn should match background
              highlight clear linenr              " current line number row will have same background color in relative mode
              set visualbell t_vb=                " turn off error beep/flash
              set novisualbell                    " turn off visual bell
              set ttyfast                         " smoother changes
              set guicursor=n-v-c:block-cursor    " cursor shape (insert => vertical line)

              if has('cmdline_info')
                  set ruler                 " show the cursor position all the time
                  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%v\ %p%)
                  set showcmd               " display incomplete commands
              endif

              if has('statusline')
                  set laststatus=2

                  " broken down into easily includeable segments
                  set statusline=%<%f\                        " filename
                  set statusline+=%w%h%m%r                    " options
                  set statusline+=%{fugitive#statusline()}    " git
                  set statusline+=\ [%{&ff}/%y]               " filetype
                  set statusline+=\ [%{getcwd()}]             " current dir
                  set statusline+=\ [a=\%03.3b/h=\%02.2b]     " ascii / hexadecimal value of char
                  set statusline+=%=%-14.(%l,%c%v%)\ %p%%     " right aligned file nav info
              endif

              set backspace=2                     " make backspace like most other apps
              set linespace=0                     " no extra space between rows
              set showmatch                       " show matching brackets/parens
              set number                          " show line numbers
              set incsearch                       " do incremental searching
              set hlsearch                        " highligh searches
              set ignorecase                      " ignore case when searching
              set smartcase                       " ... but not when uppercase is used
              set wildmenu                        " show list instead of just completing
              set wildmode=list:longest,full      " command <tab> completion, list matches, then longest common part, then all.
              set whichwrap=b,s,h,l,<,>,[,]       " move freely between files
              set scrolljump=5                    " lines to scroll when cursor leaves screen
              set scrolloff=3                     " keep 3 lines when scrolling
              " set foldenable                      " auto fold code
              set list
              set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " highlight problematic whitespace
              set splitright                      " put new vsplit windows to the right of the current
              set splitbelow                      " put new split windows to the bottom of the current
          " }
      "}

      " Formatting {
          set nowrap                        " don't wrap long lines
          set autoindent                    " indent at the same level of the previous line
          set tabstop=2                     " numbers of spaces of tab character
          set shiftwidth=2                  " numbers of spaces to (auto)indent
          set expandtab                     " tabs are converted to spaces, use only when required
          set softtabstop=2                 " let backspace delete indent
          set pastetoggle=<F12>             " pastetoggle (sane indentation on pastes)

          if has("autocmd")
              au FileType c,cpp,java,scala,go,php,javascript,puppet,python,rust,twig,xml,yml,perl au BufWritePre <buffer> call StripTrailingWhitespace()
              au BufNewFile,BufRead  *.scala    set syntax=scala
              au FileType haskell setlocal commentstring=--\ %s
          endif
      " }

      " key (re)mapping {
          " derleader & localleader to space; make space nop
          nnoremap <space> <nop>
          let mapleader = ','
          let maplocalleader = ',,'

          " easier moving in tabs and windows
          map <c-j> <c-w>j<c-w>_
          map <c-k> <c-w>k<c-w>_
          map <c-l> <c-w>l<c-w>_
          map <c-h> <c-w>h<c-w>_

          " move between tabs (next an previous)
          map <s-h> gt
          map <s-l> gt

          " move between buffers like tabs
          map gb :bn<cr>

          " yank from the cursor to the end of the line, to be consistent with c and d.
          nnoremap y y$

          " code folding options
          nmap <leader>f0 :set foldlevel=0<cr>
          nmap <leader>f1 :set foldlevel=1<cr>
          nmap <leader>f2 :set foldlevel=2<cr>
          nmap <leader>f3 :set foldlevel=3<cr>
          nmap <leader>f4 :set foldlevel=4<cr>
          nmap <leader>f5 :set foldlevel=5<cr>
          nmap <leader>f6 :set foldlevel=6<cr>
          nmap <leader>f7 :set foldlevel=7<cr>
          nmap <leader>f8 :set foldlevel=8<cr>
          nmap <leader>f9 :set foldlevel=9<cr>

          " clearing highlighted search
          nmap <silent> <leader>/ :nohlsearch<cr>

          " find merge conflict markers
          map <leader>fc /\v^[<\|=>]{7}( .*\|$)<cr>

          " visual shifting (does not exit visual mode)
          vnoremap < <gv
          vnoremap > >gv

          " for when you forget to sudo.. really write the file.
          cmap w!! w !sudo tee % >/dev/null

          " helpers to edit mode
          cnoremap %% <c-r>=expand('%:h').'/'<cr>
          map <leader>ew :e %%
          map <leader>es :sp %%
          map <leader>ev :vsp %%
          map <leader>et :tabe %%

          " map <leader>ff to display all lines with keyword under cursor and ask which one to jump to
          nmap <leader>ff [i:let nr = input("which one: ")<bar>exe "normal " . nr ."[\t"<cr>

          " fix home and end keybindings for screen, particularly on mac
          " - for some reason this fixes the arrow keys too. huh.
          map [f $
          imap [f $
          map [h g0
          imap [h g0
      " }

      " plugins settings {
          " airline {
              let g:airline#extensions#tabline#enabled = 1
              let g:airline#extensions#tabline#show_splits = 1
              let g:airline_powerline_fonts = 1
          " }

          " ctrlp {
              let g:ctrlp_working_path_mode = 'ra'
              let g:ctrlp_show_hidden = 1
              let g:ctrlp_custom_ignore = {
                  \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                  \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }
              if executable('ag')
                  let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
              elseif executable('ack-grep')
                  let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
              elseif executable('ack')
                  let s:ctrlp_fallback = 'ack %s --nocolor -f'
              else
                  let s:ctrlp_fallback = 'find %s -type f'
              endif
              let g:ctrlp_user_command = {
                  \ 'types': {
                      \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                      \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                  \ },
                  \ 'fallback': s:ctrlp_fallback
              \ }
          "}

          " Fugitive {
                let g:signify_sign_show_count = 1
                nnoremap <silent> <leader>gs :Gstatus<CR>
                nnoremap <silent> <leader>gd :Gdiff<CR>
                nnoremap <silent> <leader>gc :Gcommit<CR>
                nnoremap <silent> <leader>gb :Gblame<CR>
                nnoremap <silent> <leader>gl :Glog<CR>
                nnoremap <silent> <leader>gp :Git push<CR>
                nnoremap <silent> <leader>gr :Gread<CR>
                nnoremap <silent> <leader>gw :Gwrite<CR>
                nnoremap <silent> <leader>ge :Gedit<CR>
                nnoremap <silent> <leader>gi :Git add -p %<CR>
                nnoremap <silent> <leader>gg :SignifyToggle<CR>
          " }

          " NerdTree {
              map <C-e> <plug>NERDTreeTabsToggle<CR>
              map <leader>e :NERDTreeFind<CR>
              nmap <leader>nt :NERDTreeFind<CR>

              let NERDTreeShowBookmarks=0

              let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
              let NERDTreeChDirMode=0
              let NERDTreeQuitOnOpen=1

              let NERDTreeMouseMode=2
              let NERDTreeShowHidden=1
              let NERDTreeKeepTreeInNewTab=1
              let g:NERDShutUp=1
              let g:nerdtree_tabs_open_on_gui_startup=0
          "}

          " UndoTree {
              nnoremap <Leader>u :UndotreeToggle<CR>
              let g:undotree_SetFocusWhenToggle=1
          "}
      "}

      " Functions {
          " Initialize directories {
              function! InitializeDirectories()
                  let parent = $HOME
                  let dir_list = {
                              \ 'backup': 'backupdir',
                              \ 'views': 'viewdir',
                              \ 'swap': 'directory' }

                  if has('persistent_undo')
                      let dir_list['undo'] = 'undodir'
                  endif

                  let common_dir = parent . '/.local/share/vim/'

                  if exists("*mkdir")
                    if !isdirectory(common_dir)
                      call mkdir(common_dir)
                    endif
                  endif

                  for [dirname, settingname] in items(dir_list)
                      let directory = common_dir . dirname . '/'
                      if exists("*mkdir")
                          if !isdirectory(directory)
                              call mkdir(directory)
                          endif
                      endif
                      if !isdirectory(directory)
                          echo "Warning: Unable to create backup directory: " . directory
                          echo "Try: mkdir -p " . directory
                      else
                          let directory = substitute(directory, " ", "\\\\ ", "g")
                          exec "set " . settingname . "=" . directory
                      endif
                  endfor
              endfunction
          " }

          " Strip whitespace {
              function! StripTrailingWhitespace()
                  " Preparation: save last search, and cursor position.
                  let _s=@/
                  let l = line(".")
                  let c = col(".")
                  " do the business:
                  %s/\s\+$//e
                  " clean up: restore previous search history, and cursor position
                  let @/=_s
                  call cursor(l, c)
              endfunction
          " }
      " }

      call InitializeDirectories()
    '';

  };

}
