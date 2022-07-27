" ======= DEFAULTS ======= "

set nocompatible
set textwidth=120
set nowrap
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set number
set showmatch
set ruler
set backup
set lbr
set backupdir=~/.vim/backups
set directory=~/.vim/backups
set tags=~/.vim/tags
set shell=bash\ --login

set backupskip=/tmp/*,/private/tmp/*" 

set title
set titlestring=vim:\ %F

" turn on fold indicators
set foldcolumn=1
set fdc=2

" we get colors, we get lots and lots of colors
set bg=dark
set t_Co=256
colorscheme chili
syntax enable

" sudo-write
map :sw :w !sudo tee %


" ======= PLUGINS ======= "

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'klen/python-mode'
Plugin 'ycm-core/YouCompleteMe'

Plugin 'reedes/vim-pencil'           " writing mode
Plugin 'reedes/vim-colors-pencil'    " colors
Plugin 'tpope/vim-abolish'           " Fancy abbreviation replacements
Plugin 'junegunn/limelight.vim'      " Highlights only active paragraph
Plugin 'junegunn/goyo.vim'           " Full screen writing mode
Plugin 'reedes/vim-lexical'          " Better spellcheck mappings
Plugin 'reedes/vim-thematic'         " Themes
Plugin 'reedes/vim-litecorrect'      " Better autocorrections
Plugin 'reedes/vim-textobj-sentence' " Treat sentences as text objects
Plugin 'reedes/vim-wordy'            " Weasel words and passive voice

call vundle#end()

" omnicompletion
filetype plugin indent on


" ======= Functions ======= "

" Embedded() is a function that will parse a text buffer 
" looking for embedded vim commands, and execute them.
" Call it with a range of lines to check, eg to check the whole 
" file:
" 
"  :%call Embedded() 
"
" Commands should be prefixed by the sequence :vim: .
"
function Embedded() range
    let n = a:firstline
    while n <= a:lastline
        let l = getline(n)
        let p = stridx(l,':vim:')
        if p > -1
            let p = p + 5 
            let c = strpart(l,p)
            execute c
        endif   
        let n = n + 1 
    endwhile 
endfunction
" call Embedded() whenever a file is loaded and 
" parse the entire file.  You may not want to do 
" this for *; maybe just your src tree or certain 
" file types or something.
autocmd BufWinEnter * %call Embedded()
autocmd BufNewFile,BufRead *.less set filetype=css

" Create nested folds on custom expressions, based 
" on the current buffer's filetype or syntax. 
"
let g:foldlevel = 0
let g:foldstartexpr = ''
let g:foldendexpr   = ''
function GetCustomFold()
	if getline(v:lnum) =~ g:foldstartexpr
		let g:foldlevel = g:foldlevel + 1
		return ">".g:foldlevel
	elseif getline(v:lnum) =~ g:foldendexpr
		let thislevel = g:foldlevel
		let g:foldlevel = g:foldlevel - 1 
		return "<".thislevel
	else 
		return g:foldlevel
	endif
endfunction
function SetFoldType()
	let f = &filetype ? &filetype : &syntax
	if f == 'mason'
		let g:foldstartexpr = '^\s*<\(script\|style\|%init\|%attr\|%once\|%args\|%flags\|%shared\|%def\)[^>]*>\s*$'
		let g:foldendexpr   = '^\s*</\(script\|style\|%init\|%attr\|%once\|%args\|%flags\|%shared\|%def\)[^>]*>\s*$'
	elseif f == 'perl'
		let g:foldstartexpr = '^sub.*{\s*$'
		let g:foldendexpr   = '^}\s*$'
	elseif f == 'javascript'
		let g:foldstartexpr = '^function.*{\s*$'
		let g:foldendexpr   = '^}\s*$'
	elseif f == 'css'
		let g:foldstartexpr = '^\/\*\*\*.*\*\/$'
		let g:foldendexpr   = '^\/\*.*\*\*\*/$'
	elseif f == 'sh'
		let g:foldstartexpr = '^function.*{\s*$'
		let g:foldendexpr   = '^}\s*$'
	elseif f == 'puppet'
		let g:foldstartexpr = '^.*{[^}]*$'
		let g:foldendexpr   = '}\s*\(->\s*\)\?$'
	else 
		return
	endif
	setlocal foldexpr=GetCustomFold()
	setlocal foldmethod=expr 
endfunction
autocmd BufWinEnter * %call SetFoldType()

" ======= MAIL ======= "

autocmd FileType mail set colorcolumn=79

" ======= PERL ======= "

function SetPerlIDE()
	" check perl code with :make
	setlocal makeprg=perl\ -c\ %\ $*
	setlocal errorformat=%f:%l:%m
	setlocal autowrite
	
	" comment/uncomment blocks of code (in vmode)
	map  :s/^/#/gi<Enter>
	map  :s/^#//gi<Enter>
	
	" my perl includes pod
	let perl_include_pod = 1
	
	" syntax color complex things like @{${"foo"}}
	let perl_extended_vars = 1
	
	" Tidy selected lines (or entire file) with _t:
	nnoremap <silent> _t :%!perltidy -q<Enter>
	vnoremap <silent> _t :!perltidy -q<Enter>

	" perlcritic selected lines (or entire file) with _p:
	nnoremap <silent> _p :%!perlcritic -q<Enter>
	vnoremap <silent> _p :!perlcritic -q<Enter>
endfunction
autocmd FileType perl call SetPerlIDE()

" ======= PYTHON ======= "

function SetPythonIDE()

	match OverLength /\%<121v.\%>120v/
	let &colorcolumn=join(range(121,999),",")

    let g:pymode_options_max_line_length = 120
    let g:pymode_lint_options_pep8 = {'max_line_length': g:pymode_options_max_line_length}

	" ensure the virtual env remains configured in subshells
	set shell=bash\ --norc

	" set CTRL+R to execute the current buffer inside the virtual env
	nnoremap <buffer>  :exec '!python' shellescape(@%, 1)<cr>

endfunction
autocmd FileType python call SetPythonIDE()

" YouCompleteMe config
let g:ycm_python_interpreter_path = ''
let g:ycm_python_sys_path = []
let g:ycm_extra_conf_vim_data = [
  \  'g:ycm_python_interpreter_path',
  \  'g:ycm_python_sys_path'
  \]
let g:ycm_global_ycm_extra_conf = '~/ycm_global.py'


" ======= PROSE ======= "

augroup pencil
 autocmd!
 autocmd filetype markdown,mkd call pencil#init()
     \ | Thematic pencil
     \ | Goyo
     \ | call lexical#init()
     \ | call litecorrect#init()
     \ | setl spell spl=en_us fdl=4 noru nonu nornu
     \ | setl fdo+=search
     \ | let g:thematic#theme_name = 'pencil'
augroup END

let g:pencil#wrapModeDefault = 'soft'
let g:pencil#textwidth = 74
let g:pencil#joinspaces = 0
let g:pencil#cursorwrap = 1
let g:pencil#conceallevel = 3
let g:pencil#concealcursor = 'c'
let g:pencil#softDetectSample = 20
let g:pencil#softDetectThreshold = 130
let g:pencil_spell_undercurl = 1
let g:pencil_higher_contrast_ui = 1


let g:wordy#ring = [
  \ 'weak',
  \ ['being', 'passive-voice', ],
  \ 'weasel',
  \ ['problematic', 'redundant', ],
  \ ['colloquial', 'idiomatic', 'similies', ],
  \ 'art-jargon',
  \ ['contractions', 'opinion', 'vague-time', 'said-synonyms', ],
  \ 'adjectives',
  \ 'adverbs',
  \ ]

let g:thematic#themes = {
\ 'pencil_dark' :{'colorscheme': 'pencil',
\                 'background': 'dark',
\                 'airline-theme': 'badwolf',
\                 'ruler': 1,
\                },
\ 'pencil_lite' :{'colorscheme': 'pencil',
\                 'background': 'light',
\                 'airline-theme': 'light',
\                 'ruler': 1,
\                },
\ }

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
