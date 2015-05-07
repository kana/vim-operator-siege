runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

let g:operator_siege_decos = [
\   {'chars': ['「', '」'], 'keys': ['jk']},
\ ]

describe 'g:operator_siege_decos without objs'
  before
    new
    map <buffer> s  <Plug>(operator-siege-add)
    nmap <buffer> ds  <Plug>(operator-siege-delete)
    nmap <buffer> cs  <Plug>(operator-siege-change)
  end

  after
    close!
  end

  it 'can be used for <Plug>(operator-siege-add)'
    redir => m
    Expect Do('fasiwjk', 'foo bar baz') ==# 'foo 「bar」 baz'
    redir END
    Expect m ==# ''
  end

  it 'cannot be used for <Plug>(operator-siege-delete)'
    redir => m
    Expect Do('fadsjk', 'foo 「bar」 baz') ==# 'foo 「bar」 baz'
    redir END
    Expect m =~# 'Deco "jk" cannot be used for deletion.'
  end

  it 'cannot be used for <Plug>(operator-siege-change) replacee'
    redir => m
    Expect Do('facsjkr', 'foo 「bar」 baz') ==# 'foo 「bar」 baz'
    redir END
    Expect m =~# 'Deco "jk" cannot be used as target for change.'
  end

  it 'can be used for <Plug>(operator-siege-change) replacer'
    redir => m
    Expect Do('facsrjk', 'foo [bar] baz') ==# 'foo 「bar」 baz'
    redir END
    Expect m ==# ''
  end
end
