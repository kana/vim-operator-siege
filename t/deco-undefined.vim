runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

let g:operator_siege_decos = [
\   {'chars': ['「', '」'], 'keys': ['jk']},
\ ]

describe 'vim-operator-siege'
  before
    new
    map <buffer> s  <Plug>(operator-siege-add)
    nmap <buffer> ds  <Plug>(operator-siege-delete)
    nmap <buffer> cs  <Plug>(operator-siege-change)
  end

  after
    close!
  end

  describe '<Plug>(operator-siege-add)'
    it 'shows a message on undefined deco'
      redir => m
      Expect Do('fasiwjW', 'foo bar baz') ==# 'foo bar baz'
      redir END
      Expect m =~# 'Deco "jW" is not defined.'
    end
  end

  describe '<Plug>(operator-siege-delete)'
    it 'shows a message on undefined deco'
      redir => m
      Expect Do('fadsX', 'foo [bar] baz') ==# 'foo [bar] baz'
      redir END
      Expect m =~# 'Deco "X" is not defined.'
    end
  end

  describe '<Plug>(operator-siege-change)'
    it 'shows a message on undefined replacee deco'
      redir => m
      Expect Do('facsYr', 'foo [bar] baz') ==# 'foo [bar] baz'
      redir END
      Expect m =~# 'Deco "Y" is not defined.'
    end

    it 'shows a message on undefined replacer deco'
      redir => m
      Expect Do('facsrZ', 'foo [bar] baz') ==# 'foo [bar] baz'
      redir END
      Expect m =~# 'Deco "Z" is not defined.'
    end
  end
end
