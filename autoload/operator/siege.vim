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
  let deco = s:input_deco()
  if deco is 0
    return
  endif

  call s:add_deco(a:motionwise, deco)

  let s:first = 0
  let s:deco = deco
endfunction




function! operator#siege#change(motionwise)  "{{{2
  " TODO: Respect a:motionwise.
  let deco = s:input_deco()
  if deco is 0
    return
  endif

  " Assumes that both operations set natural positions to '[ and '].
  call operator#siege#delete(a:motionwise)
  call s:add_deco(a:motionwise, deco)

  let s:first = 0
  let s:deco = deco
endfunction




function! operator#siege#delete(motionwise)  "{{{2
  " TODO: Respect a:motionwise.
  " TODO: Consider changing the UI -- target a whole text object, not inside.
  let rc = getreg('z')
  let rt = getregtype('z')

  normal! `[
  call search('\S', 'bW')
  normal! v
  normal! `]
  call search('\S', 'W')
  normal! "zy

  let matches = matchlist(@z, '\(\S\)\(.*\)\(\S\)')
  if has_key(s:undeco_table(), matches[1] . matches[3])
    let p = col('$') - 1 == col("'>") ? 'p' : 'P'
    normal! `<v`>"_d
    let @z = matches[2]
    " p is important to set meaningful positions to '[ and '], and
    " `[ is important to locate the cursor at the natural position.
    execute 'normal!' '"z'.p.'`['
  endif

  call setreg('z', rc, rt)
endfunction








" Misc.  "{{{1
function! operator#siege#mark_as_first()  "{{{2
  let s:first = 1
endfunction




function! s:deco_table()  "{{{2
  if s:user_deco_table isnot g:siege_deco_table
    let s:user_deco_table = g:siege_deco_table
    let s:unified_deco_table = {}
    call extend(s:unified_deco_table, s:default_deco_table)
    call extend(s:unified_deco_table, s:user_deco_table)
  endif
  return s:unified_deco_table
endfunction

let s:unified_deco_table = {}

" TODO: Support at/it.
let s:default_deco_table = [
\   {'chars': ['(', ')'], 'keys': ['(', ')', 'b']},
\   {'chars': ['<', '>'], 'keys': ['<', '>', 'a']},
\   {'chars': ['[', ']'], 'keys': ['[', ']', 'r']},
\   {'chars': ['{', '}'], 'keys': ['{', '}', 'B']},
\   {'chars': ["'", "'"], 'keys': ["'"]},
\   {'chars': ['"', '"'], 'keys': ['"']},
\   {'chars': ['`', '`'], 'keys': ['`']},
\ ]

if !exists('g:siege_deco_table')
  let g:siege_deco_table = {}
endif
let s:user_deco_table = {}




function! s:key_table()  "{{{2
  let deco_table = s:deco_table()
  if s:_key_deco_table isnot deco_table
    let s:_key_deco_table = deco_table
    let s:key_table = s:make_key_table(deco_table)
  endif
  return s:key_table
endfunction

let s:_key_deco_table = {}




function! s:make_key_table(deco_table)  "{{{2
  let key_table = {}
  let keys = keys(a:deco_table)
  call sort(keys)
  for k in keys
    for i in range(len(k) - 1)
      let key_table[k[0:i]] = s:INCOMPLETE_KEY
    endfor
    let key_table[k] = s:COMPLETE_KEY
  endfor
  return key_table
endfunction

let s:WRONG_KEY = 0
let s:INCOMPLETE_KEY = 1
let s:COMPLETE_KEY = 2




function! s:undeco_table()  "{{{2
  let deco_table = s:deco_table()
  if s:_deco_table isnot deco_table
    let s:_deco_table = deco_table
    let s:undeco_table = {}
    for v in values(deco_table)
      let s:undeco_table[v[0] . v[1]] = 1
    endfor
  endif
  return s:undeco_table
endfunction

let s:_deco_table = {}




function! s:add_deco(motionwise, deco)  "{{{2
  " TODO: Respect a:motionwise.
  let rc = getreg('z')
  let rt = getregtype('z')

  let p = col('$') - 1 == col("']") ? 'p' : 'P'
  normal! `[v`]"zd
  let @z = a:deco[0] . @z . a:deco[1]
  " p is important to set meaningful positions to '[ and '], and
  " `[ is important to locate the cursor at the natural position.
  execute 'normal!' '"z'.p.'`['

  call setreg('z', rc, rt)
endfunction




function! s:input_deco()  "{{{2
  if s:first
    let key_table = s:key_table()
    let key = ''
    while 1
      let key .= nr2char(getchar())
      let type = get(key_table, key, s:WRONG_KEY)
      if type == s:COMPLETE_KEY
        return get(s:deco_table(), key, 0)
      elseif type == s:INCOMPLETE_KEY
        continue
      else  " type == s:WRONG_KEY
        return 0
      endif
    endwhile
  else
    return s:deco
  endif
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
