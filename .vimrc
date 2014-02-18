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

function SetPythonIDE()

	set expandtab

	" set line widths to 100
	set textwidth=100
	match OverLength /\%<101v.\%>100v/
	let &colorcolumn=join(range(101,999),",")

    " automatically fix PEP8 errors with CTRL+P
	map  :PyFlakeAuto<Enter>

    " shut up about PEP8 E309, blank lines after class defs.
    let g:PyFlakeDisabledMessages = 'E501,E309'

	" activate the virtual env in vim, for omnicompletes etc.
	if !empty($VIRTUAL_ENV)
		:python << EOF
import os
virtualenv = os.environ.get('VIRTUAL_ENV', None)
if virtualenv:
    activate_this = os.path.join(virtualenv, 'bin', 'activate_this.py')
if os.path.exists(activate_this):
    execfile(activate_this, dict(__file__=activate_this))
EOF
	endif

	" ensure the virtual env remains configured in subshells
	set shell=bash\ --norc

	" set CTRL+R to execute the current buffer inside the virtual env
	nnoremap <buffer>  :exec '!python' shellescape(@%, 1)<cr>

endfunction
autocmd FileType python call SetPythonIDE()

" visual line-length indicator for mail
autocmd FileType mail set colorcolumn=72

" map II :r ~/.vim/template.pod<CR>

map :sw :w !sudo tee %

set textwidth=100
set nowrap
set tabstop=4
set softtabstop=4
set shiftwidth=4
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

call pathogen#infect()
call pathogen#helptags()

" omnicompletion
filetype plugin indent on
set ofu=syntaxcomplete#Complete

" remap completion to control+space
inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
\ "\<lt>C-n>" :
\ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
\ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
\ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"
imap <C-@> <C-Space>

" use the tab key as the tab key
let g:SuperTabMappingTabLiteral = '<tab>'

" macvim options
if has("gui_running")
	set gfn=Menlo:h12
	set guioptions-=r
	set guioptions-=L
	set guioptions-=T
	set transparency=10
	macm Window.Select\ Previous\ Tab  key=<D-S-Left>
	macm Window.Select\ Next\ Tab	   key=<D-S-Right>
endif
