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
function! operator#siege#prepare_to_add(indented)  "{{{2
  let s:indented = a:indented
  let s:first = 1
endfunction




function! operator#siege#add(motionwise)  "{{{2
  let deco = s:first ? s:input_deco(1) : s:deco_to_add
  if deco is 0
    return
  endif

  call s:add_deco(a:motionwise, deco)

  let s:first = 0
  let s:deco_to_add = deco
endfunction




function! operator#siege#prepare_to_change()  "{{{2
  " TODO: Show a friendly message on failure.
  let deco_to_delete = s:input_deco(0)
  if deco_to_delete is 0
    return ''
  endif
  let deco_to_add = s:input_deco(1)
  if deco_to_add is 0
    return ''
  endif

  let s:deco_to_delete = deco_to_delete
  let s:deco_to_add = deco_to_add
  return "\<Plug>(operator-siege-%change)" . deco_to_delete.objs[1]
endfunction




function! operator#siege#change(motionwise)  "{{{2
  " Assumption: s:deco_to_delete and s:deco_to_add are set by the caller.
  " TODO: Respect a:motionwise.

  " Assumes that both operations set natural positions to '[ and '].
  call operator#siege#delete(a:motionwise)  " s:deco_to_delete
  call s:add_deco(a:motionwise, s:deco_to_add)
endfunction




function! operator#siege#prepare_to_delete()  "{{{2
  let deco = s:input_deco(0)
  if deco is 0
    " TODO: Show a friendly message on failure.
    return ''
  endif

  let s:deco_to_delete = deco
  return "\<Plug>(operator-siege-%delete)" . deco.objs[1]
endfunction




function! operator#siege#delete(motionwise)  "{{{2
  " Assumption: s:deco_to_delete is set by the caller.
  " TODO: Respect a:motionwise.
  let rc = getreg('z')
  let rt = getregtype('z')

  let ib = getpos("'[")
  let ie = getpos("']")
  normal! v
  execute 'normal' s:deco_to_delete.objs[0]
  execute 'normal!' "\<Esc>"
  let ob = getpos("'<")
  let oe = getpos("'>")

  let [bsp, bc, core, ec, esp] = s:parse_context(ob, oe, ib, ie)
  let p = col([oe[1], '$']) - 1 == oe[2] ? 'p' : 'P'
  call setpos('.', ob)
  normal! v
  call setpos('.', oe)
  normal! "_d
  " p is important to set meaningful positions to '[ and '], and
  if bsp == '' && esp == ''
    silent execute 'normal!' "\"=core\<CR>".p
  elseif bsp != '' && esp == ''
    silent execute 'normal!' "\"=bsp\<CR>".p."\"=core\<CR>p"
  elseif bsp == '' && esp != ''
    silent execute 'normal!' "\"=esp\<CR>".p."`[\"=core\<CR>P"
  else  " if bsp != '' && esp != ''
    silent execute 'normal!' "\"=bsp\<CR>".p."\"=esp\<CR>p`[\"=core\<CR>P"
  endif
  " `[ is important to locate the cursor at the natural position.
  normal! `[

  call setreg('z', rc, rt)
endfunction








" Misc.  "{{{1
function! s:deco_table()  "{{{2
  if s:user_decos isnot g:siege_decos
    let s:user_decos = g:siege_decos
    let all_decos = s:default_decos + s:user_decos
    let s:unified_deco_table = s:make_deco_table(all_decos)
  endif
  return s:unified_deco_table
endfunction

let s:unified_deco_table = {}

let s:default_decos = [
\   {'chars': ['(', ')'], 'objs': ['a(', 'i('], 'keys': ['(', ')', 'b']},
\   {'chars': ['<', '>'], 'objs': ['a<', 'i<'], 'keys': ['>', 'a']},
\   {'chars': ['[', ']'], 'objs': ['a[', 'i['], 'keys': ['[', ']', 'r']},
\   {'chars': ['{', '}'], 'objs': ['a{', 'i{'], 'keys': ['{', '}', 'B']},
\   {'chars': ["'", "'"], 'objs': ["a'", "i'"], 'keys': ["'"]},
\   {'chars': ['"', '"'], 'objs': ['a"', 'i"'], 'keys': ['"']},
\   {'chars': ['`', '`'], 'objs': ['a`', 'i`'], 'keys': ['`']},
\   {'chars': ["<\1>", "</\1>"], 'objs': ['at', 'it'], 'keys': ['<', 't'],
\    'finisher': '>'},
\ ]

if !exists('g:siege_decos')
  let g:siege_decos = []
endif
let s:user_decos = []




function! s:make_deco_table(decos)  "{{{2
  let deco_table = {}
  for d in a:decos
    for k in d.keys
      let deco_table[k] = d
    endfor
  endfor
  return deco_table
endfunction




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
    for d in values(deco_table)
      let s:undeco_table[d.chars[0] . d.chars[1]] = 1
    endfor
  endif
  return s:undeco_table
endfunction

let s:_deco_table = {}




function! s:input_deco(expand)  "{{{2
  let key_table = s:key_table()
  let key = ''
  while 1
    let key .= nr2char(getchar())
    let type = get(key_table, key, s:WRONG_KEY)
    if type == s:COMPLETE_KEY
      let deco = s:deco_table()[key]
      return a:expand ? s:expand_deco(deco) : deco
    elseif type == s:INCOMPLETE_KEY
      continue
    else  " type == s:WRONG_KEY
      return 0
    endif
  endwhile
endfunction




function! s:expand_deco(deco)  "{{{2
  " Expand at most one placeholder.
  " TODO: Support more placeholders?
  " TODO: Support custom expander for each deco?
  let i = stridx(a:deco.chars[0], "\1")
  if i < 0
    return a:deco
  endif

  let original_map = s:set_up_finisher(a:deco)
  let r = input(a:deco.chars[0][0:i-1])
  call s:clean_up_finisher(a:deco, original_map)

  let deco = copy(a:deco)
  let deco.chars = [
  \   substitute(deco.chars[0], "\1", r, 'g'),
  \   substitute(deco.chars[1], "\1", r, 'g'),
  \ ]
  return deco
endfunction




function! s:set_up_finisher(deco)  "{{{2
  if !has_key(a:deco, 'finisher')
    return 0
  endif

  let original_map = maparg(a:deco.finisher, 'c', 0, 1)
  execute 'cnoremap' '<buffer>' a:deco.finisher  '<Return>'
  return original_map
endfunction




function! s:clean_up_finisher(deco, original_map)  "{{{2
  if a:original_map is 0
    return
  endif

  if empty(a:original_map) || !a:original_map.buffer
    execute 'cunmap' '<buffer>' a:deco.finisher
  else
    call s:restore_map(a:original_map)
  endif
endfunction




function! s:restore_map(original_map)  "{{{2
  execute (a:original_map.noremap ? 'cnoremap' : 'cmap')
  \       (a:original_map.silent ? '<silent>' : '')
  \       (a:original_map.expr ? '<expr>' : '')
  \       (a:original_map.buffer ? '<buffer>' : '')
  \       (get(a:original_map, 'nowait', 0) ? '<nowait>' : '')
  \       a:original_map.lhs
  \       a:original_map.rhs
endfunction




function! s:add_deco(motionwise, deco)  "{{{2
  let uc = getreg('"')
  let ut = getregtype('"')
  let zc = getreg('z')
  let zt = getregtype('z')

  call s:add_deco_{a:motionwise}wise(a:deco)

  call setreg('"', uc, ut)
  call setreg('z', zc, zt)
endfunction




function! s:add_deco_charwise(deco)  "{{{2
  let p = col('$') - 1 == col("']") ? 'p' : 'P'
  normal! `[v`]"zd
  let @z = a:deco.chars[0] . @z . a:deco.chars[1]
  " p is important to set meaningful positions to '[ and '], and
  " `[ is important to locate the cursor at the natural position.
  execute 'normal!' '"z'.p.'`['
endfunction




function! s:add_deco_linewise(deco)  "{{{2
  normal! `[V`]"zy
  let indent = matchstr(@z, '^\s*')
  let @z = indent . a:deco.chars[0] . "\n"
  \      . @z
  \      . indent . a:deco.chars[1] . "\n"
  " p is important to set meaningful positions to '[ and '], and
  " v_p is important to avoid unexpected results on edge cases.
  normal! `[V`]"zp
endfunction




function! s:add_deco_blockwise(deco)  "{{{2
  call s:add_deco_charwise(a:deco)  " TODO: Implement a custom logic.
endfunction




function! s:parse_context(ob, oe, ib, ie)  "{{{2
  " AAA 'BBB CCC' DDD
  "     ^^     ^ ^
  "    /  \   /   \
  "   ob  ib ie    oe

  let rc = getreg('z')
  let rt = getregtype('z')

  call setpos('.', a:ob)
  normal! v
  call setpos('.', a:ib)
  call search('.', 'bW')
  normal! "zy
  let bmatches = matchlist(@z, '^\(\s*\)\(.*\)')
  let bsp = bmatches[1]
  let bc = bmatches[2]

  call setpos('.', a:ie)
  call search('.', 'W')
  normal! v
  call setpos('.', a:oe)
  normal! "zy
  let ematches = matchlist(@z, '\(.\{-}\)\(\s*\)$')
  let ec = ematches[1]
  let esp = ematches[2]

  call setpos('.', a:ib)
  normal! v
  call setpos('.', a:ie)
  normal! "zy
  let core = @z

  call setreg('z', rc, rt)

  return [bsp, bc, core, ec, esp]
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
