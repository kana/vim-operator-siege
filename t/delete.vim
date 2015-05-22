runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

describe '<Plug>(operator-siege-delete)'
  before
    new
    nmap <buffer> ds  <Plug>(operator-siege-delete)
  end

  after
    close!
  end

  it 'deletes target decoration characters which enclose the cursor'
    Expect Do('dsb', '(foo) (bar) (baz)') ==# 'foo (bar) (baz)'
    Expect Do('fzdsb', '(foo) (bar) (baz)') ==# '(foo) (bar) baz'
  end

  it 'deletes target decoration characters without content'
    Expect Do('f(dsb', 'foo () bar') ==# 'foo  bar'
    Expect Do('f)dsb', 'foo () bar') ==# 'foo  bar'
    Expect Do('f(dsb', '(foo () bar)') ==# '(foo  bar)'
    Expect Do('f)dsb', '(foo () bar)') ==# '(foo  bar)'
    Expect Do('f"ds"', 'foo "" bar') ==# 'foo  bar'
    Expect Do('f"ds"', 'foo "".bar') ==# 'foo .bar'
    Expect Do('f"ds"', 'foo."" bar') ==# 'foo. bar'
  end

  it 'deletes target linewise if decoration characters are placed linewise'
    Expect Do('dsB', [
    \   '{',
    \   '  {',
    \   '    foo',
    \   '  }',
    \   '}',
    \ ]) ==# [
    \   '  {',
    \   '    foo',
    \   '  }',
    \ ]
    Expect Do('jjdsB', [
    \   '{',
    \   '  {',
    \   '    foo',
    \   '  }',
    \   '}',
    \ ]) ==# [
    \   '{',
    \   '    foo',
    \   '}',
    \ ]
  end
end

