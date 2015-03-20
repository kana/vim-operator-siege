runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

describe '<Plug>(operator-siege-delete)'
  before
    new
    map <buffer> ds  <Plug>(operator-siege-delete)
  end

  after
    close!
  end

  it 'deletes target decoration characters which enclose the cursor'
    Expect Do('dsb', '(foo) (bar) (baz)') ==# 'foo (bar) (baz)'
    Expect Do('fzdsb', '(foo) (bar) (baz)') ==# '(foo) (bar) baz'
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

  it 'is repeatable'
    SKIP 'Redo buffer is not recorded correctly in a test script.'
    Expect Do('dsb2fb.', '(foo) (bar) (baz)') ==# 'foo (bar) baz'
  end
end

