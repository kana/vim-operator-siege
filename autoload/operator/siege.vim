" vim-operator-siege - Operator to besiege text
" Version: 0.0.0
" Copyright (C) 2015 Kana Natsuno <http://whileimautomaton.net/>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Interface  "{{{1
function! operator#siege#add(motionwise)  "{{{2
  " TODO: Respect a:motionwise.
  let deco = s:input_deco()
  if deco is 0
    return
  endif

  let z = getpos("'z")

  call setpos("'z", getpos("'["))
  execute 'normal!' printf("`]a%s\<Esc>`zi%s\<Esc>", deco[1], deco[0])

  call setpos("'z", z)

  let s:first = 0
  let s:deco = deco
endfunction




function! operator#siege#change(motionwise)  "{{{2
  " TODO: Respect a:motionwise.
  let deco = s:input_deco()
  if deco is 0
    return
  endif

  let rc = getreg('z')
  let rt = getregtype('z')

  normal! `[
  call search('\S', 'bW')
  normal! v
  normal! `]
  call search('\S', 'W')
  execute 'normal!' "\<Esc>"

  normal! `<"zyl
  let bc = @z
  normal! `>"zyl
  let ec = @z

  if has_key(s:undeco_table(), bc . ec)
    execute 'normal!' '`>r'.deco[1]
    execute 'normal!' '`<r'.deco[0]
  endif

  call setreg('z', rc, rt)
endfunction




function! operator#siege#delete(motionwise)  "{{{2
  " TODO: Respect a:motionwise.
  let rc = getreg('z')
  let rt = getregtype('z')

  normal! `[
  call search('\S', 'bW')
  normal! v
  normal! `]
  call search('\S', 'W')
  execute 'normal!' "\<Esc>"

  normal! `<"zyl
  let bc = @z
  normal! `>"zyl
  let ec = @z

  if has_key(s:undeco_table(), bc . ec)
    normal! `>"_x
    normal! `<"_x
  endif

  call setreg('z', rc, rt)
endfunction








" Misc.  "{{{1
function! operator#siege#mark_as_first()  "{{{2
  let s:first = 1
endfunction




" s:deco_table  "{{{2
" TODO: Support user-level customization.
" TODO: Support at/it.
let s:deco_table = {
\   'b': ['(', ')'],
\   '(': ['(', ')'],
\   ')': ['(', ')'],
\   'a': ['<', '>'],
\   '<': ['<', '>'],
\   '>': ['<', '>'],
\   'r': ['[', ']'],
\   '[': ['[', ']'],
\   ']': ['[', ']'],
\   'B': ['{', '}'],
\   '{': ['{', '}'],
\   '}': ['{', '}'],
\   "'": ["'", "'"],
\   '"': ['"', '"'],
\   '`': ['`', '`'],
\ }




function! s:undeco_table()  "{{{2
  if s:_deco_table isnot s:deco_table
    let s:_deco_table = s:deco_table
    let s:undeco_table = {}
    for v in values(s:deco_table)
      let s:undeco_table[v[0] . v[1]] = 1
    endfor
  endif
  return s:undeco_table
endfunction

let s:_deco_table = {}




function! s:delete_or_change(deco)  "{{{2
  let rc = getreg('z')
  let rt = getregtype('z')

  normal! `[
  call search('\S', 'bW')
  normal! v
  normal! `]
  call search('\S', 'W')
  execute 'normal!' "\<Esc>"

  normal! `<"zyl
  let bc = @z
  normal! `>"zyl
  let ec = @z

  if has_key(s:undeco_table(), bc . ec)
    if a:deco is 0
      normal! `>"_x
      normal! `<"_x
    else
      execute 'normal!' '`>r'.a:deco[1]
      execute 'normal!' '`<r'.a:deco[0]
    endif
  endif

  call setreg('z', rc, rt)
endfunction




function! s:input_deco()  "{{{2
  if s:first
    " TODO: Support user input with two or more characters.
    return get(s:deco_table, nr2char(getchar()), 0)
  else
    return s:deco
  endif
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
