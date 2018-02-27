" vim-operator-siege - Operator to besiege text
" Version: 0.0.2
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
  if !get(deco, 'valid', 1)
    echo printf('Deco "%s" is not defined.', deco.key)
    return
  endif

  call s:add_deco(a:motionwise, 0, s:indented, deco)

  let s:first = 0
  let s:deco_to_add = deco
endfunction




function! operator#siege#prepare_to_change()  "{{{2
  let deco_to_delete = s:input_deco(0)
  if !get(deco_to_delete, 'valid', 1)
    echo printf('Deco "%s" is not defined.', deco_to_delete.key)
    return ''
  endif
  if !has_key(deco_to_delete, 'objs')
    echo printf('Deco "%s" cannot be used as target for change.',
    \           deco_to_delete.keys[0])
    return ''
  endif
  let deco_to_add = s:input_deco(1)
  if !get(deco_to_add, 'valid', 1)
    echo printf('Deco "%s" is not defined.', deco_to_add.key)
    return ''
  endif

  let s:deco_to_delete = deco_to_delete
  let s:deco_to_add = deco_to_add
  " NB: g@iX and yiX don't set the same '[ and '].
  return "\<Plug>(operator-siege-%change)" . deco_to_delete.objs[0]
endfunction




function! operator#siege#change(motionwise)  "{{{2
  " Assumption: s:deco_to_delete and s:deco_to_add are set by the caller.
  " NB: a:motionwise is ignored; it is automatically detected from context.

  " Assumes that both operations set natural positions to '[ and '].
  let [mw, indent] = s:delete_deco(s:deco_to_delete)
  call s:add_deco(mw, indent, 0, s:deco_to_add)
endfunction




function! operator#siege#prepare_to_delete()  "{{{2
  let deco = s:input_deco(0)
  if !get(deco, 'valid', 1)
    echo printf('Deco "%s" is not defined.', deco.key)
    return ''
  endif
  if !has_key(deco, 'objs')
    echo printf('Deco "%s" cannot be used for deletion.', deco.keys[0])
    return ''
  endif

  let s:deco_to_delete = deco
  " NB: g@iX and yiX don't set the same '[ and '].
  return "\<Plug>(operator-siege-%delete)" . deco.objs[0]
endfunction




function! operator#siege#delete(motionwise)  "{{{2
  " Assumption: s:deco_to_delete is set by the caller.
  " NB: a:motionwise is ignored; it is automatically detected from context.
  call s:delete_deco(s:deco_to_delete)
endfunction








" Misc.  "{{{1
function! s:deco_table()  "{{{2
  if s:user_decos isnot g:operator_siege_decos
    let s:user_decos = g:operator_siege_decos
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
\   {'chars': ["'", "'"], 'objs': ["a'", "i'"], 'keys': ["'"], 'offset': 1},
\   {'chars': ['"', '"'], 'objs': ['a"', 'i"'], 'keys': ['"'], 'offset': 1},
\   {'chars': ['`', '`'], 'objs': ['a`', 'i`'], 'keys': ['`'], 'offset': 1},
\   {'chars': ["<\1>", "</\1>"], 'objs': ['at', 'it'], 'keys': ['<', 't'],
\    'finisher': '>'},
\   {'chars': ['@', '@'], 'keys': ['@']},
\   {'chars': ['*', '*'], 'keys': ['*']},
\   {'chars': ['+', '+'], 'keys': ['+']},
\   {'chars': ['_', '_'], 'keys': ['_']},
\   {'chars': ['|', '|'], 'keys': ['|']},
\   {'chars': ['$', '$'], 'keys': ['$']},
\ ]

if !exists('g:operator_siege_decos')
  let g:operator_siege_decos = []
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




function! s:input_deco(expand)  "{{{2
  let key_table = s:key_table()
  let spaced = v:false
  let key = ''
  while 1
    let k = nr2char(getchar())
    if k == ' ' && key == '' && !spaced
      let spaced = v:true
      continue
    endif
    let key .= k

    let type = get(key_table, key, s:WRONG_KEY)
    if type == s:COMPLETE_KEY
      let deco = copy(s:deco_table()[key])
      let deco = a:expand ? s:expand_deco(deco) : deco
      let deco.spaced = spaced
      return deco
    elseif type == s:INCOMPLETE_KEY
      continue
    else  " type == s:WRONG_KEY
      return {'valid': 0, 'key': key}
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




function! s:add_deco(motionwise, deleted_indent, indented, deco)  "{{{2
  let uc = getreg('"')
  let ut = getregtype('"')
  let zc = getreg('z')
  let zt = getregtype('z')

  call s:add_deco_{a:motionwise}wise(a:deleted_indent, a:indented, a:deco)

  call setreg('"', uc, ut)
  call setreg('z', zc, zt)
endfunction




function! s:add_deco_charwise(deleted_indent, indented, deco)  "{{{2
  let p = col([line("']"), '$']) - 1 == col("']") ? 'p' : 'P'
  normal! `[v`]"zd
  let s = a:deco.spaced ? ' ' : ''
  let @z = a:deco.chars[0] . s . @z . s . a:deco.chars[1]
  " p is important to set meaningful positions to '[ and '], and
  " `[ is important to locate the cursor at the natural position.
  execute 'normal!' '"z'.p.'`['
endfunction




function! s:add_deco_linewise(deleted_indent, indented, deco)  "{{{2
  normal! `[V`]"zy
  let indent = a:deleted_indent is 0 ? matchstr(@z, '^\s*') : a:deleted_indent
  let @z = indent . a:deco.chars[0] . "\n"
  \      . (a:indented ? s:indent(@z) : @z)
  \      . indent . a:deco.chars[1] . "\n"
  " p is important to set meaningful positions to '[ and '], and
  " v_p is important to avoid unexpected results on edge cases.
  normal! `[V`]"zp
endfunction




function! s:add_deco_blockwise(deleted_indent, indented, deco)  "{{{2
  " TODO: Implement a custom logic.
  call s:add_deco_charwise(a:deleted_indent, a:indented, a:deco)
endfunction




function! s:delete_deco(deco)  "{{{2
  let ob = getpos("'[")
  let oe = getpos("']")
  call setpos('.', ob)
  call search('\S', 'cW')  " Skip spaces included by a' and others.
  if get(a:deco, 'offset', 0)
    " Skip opening quote to target the correct block in nested quotes.
    " For example:
    "
    "     'foo 'bar' baz'
    "     AAAAAABBBCCCCCC
    "
    " The cursor must be located at B to target 'bar' by a' and i'.
    call search('\S', 'W')
  endif

  normal! v
  execute 'normal' s:deco_to_delete.objs[1]
  execute 'normal!' "\<Esc>"
  let ib = getpos("'<")
  let ie = getpos("'>")

  let [mw, indent, bsp, bc, core, ec, esp]
  \ = s:parse_context(ob, oe, ib, ie, a:deco)
  call setpos('.', ob)
  execute 'normal!' operator#user#visual_command_from_wise_name(mw)
  call setpos('.', oe)
  " p is important to set meaningful positions to '[ and '], and
  if bsp != ''
    silent execute 'normal!' "\"=bsp\<CR>p"
  endif
  if esp != ''
    silent execute 'normal!' "\"=esp\<CR>p`["
  endif
  if core != ''
    let p = esp == '' ? 'p' : 'P'
    silent execute 'normal!' "\"=core\<CR>".p
  else
    " Replacing a region with an empty string is usually equivalent to delete
    " the region.  But such replacing does not work for linewise region.
    silent execute 'normal! d'
  endif
  " `[ is important to locate the cursor at the natural position.
  normal! `[

  return [mw, indent]
endfunction




function! s:indent(content)  "{{{2
  let indent = repeat(' ', &l:shiftwidth ? &l:shiftwidth : &l:tabstop)
  let lines = split(a:content, '\n', 1)[:-2]
  if &l:expandtab
    call map(lines, 'indent . v:val')
  else
    call map(lines, 's:unexpand_tabs(indent . s:expand_tabs(v:val))')
  endif
  return join(lines, "\n") . "\n"
endfunction




function! s:expand_tabs(line)  "{{{2
  " Assumption: Tabs don't appear in the middle of indentation.
  let tabs = matchstr(a:line, '^\t\+')
  return substitute(a:line, '^\t\+', repeat(' ', &l:tabstop * len(tabs)), '')
endfunction




function! s:unexpand_tabs(line)  "{{{2
  let spaces = matchstr(a:line, '^ \+')
  let tabs = len(spaces) / &l:tabstop
  return repeat("\t", tabs) . a:line[(tabs * &l:tabstop):]
endfunction




function! s:parse_context(ob, oe, ib, ie, deco)  "{{{2
  " AAA 'BBB CCC' DDD
  "     ^^     ^ ^
  "    /  \   /   \
  "   ob  ib ie    oe

  let rc = getreg('z')
  let rt = getregtype('z')

  if s:pos_lt(a:ob, a:ib) && s:pos_lt(a:ie, a:oe)
    call setpos('.', a:ob)
    normal! v
    call setpos('.', a:ib)
    call search('.', 'bW')
    normal! "zy
    let bmatches = matchlist(@z, '^\(\s*\)\(.*\)')
    let bsp = bmatches[1]
    let bc = bmatches[2]

    call setpos('.', a:oe)
    normal! v
    call setpos('.', a:ie)
    call search('.', 'W')
    normal! "zy
    let ematches = matchlist(@z, '\(.\{-}\)\(\s*\)$')
    let ec = ematches[1]
    let esp = ematches[2]

    normal! v
    call setpos('.', a:ib)
    normal! o
    call setpos('.', a:ie)
    normal! "zy
    let core = @z
  else
    " aX region does not contain iX region.  So that iX seems to be empty.
    " In this case, a:ob/a:oe and a:ib/i:oe represent different objects.
    " Therefore bc and ec cannot be calculated from these positions.
    " [X] TODO: Support decos with placeholders.
    call setpos('.', a:ob)
    normal! v
    call setpos('.', a:oe)
    normal! "zy
    let matches = matchlist(@z, '^\(\s*\)\(.\{-}\)\(\s*\)$')
    let bsp = matches[1]
    let bc = a:deco.chars[0]  " [X]
    let core = ''
    let ec = a:deco.chars[1]  " [X]
    let esp = matches[3]
  endif

  let V = s:strip(getline(a:ob[1])) ==# s:strip(bc)
  \    && s:strip(getline(a:oe[1])) ==# s:strip(ec)
  let indent = V ? matchstr(getline(a:ob[1]), '^\s*') : 0

  call setreg('z', rc, rt)

  return [V ? 'line' : 'char', indent, bsp, bc, core, ec, esp]
endfunction




function! s:strip(s)  "{{{2
  return matchstr(a:s, '^\s*\zs.\{-}\ze\s*$')
endfunction








function! s:pos_lt(pa, pb)  "{{{2
  return a:pa[1] < a:pb[1] || a:pa[1] == a:pb[1] && a:pa[2] < a:pb[2]
endfunction




" __END__  "{{{1
" vim: foldmethod=marker
