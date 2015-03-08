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

  it 'deletes decoration characters enclosing target region'
    Expect Do('dsib', '(foo) (bar) (baz)') ==# 'foo (bar) (baz)'
    Expect Do('fzdsib', '(foo) (bar) (baz)') ==# '(foo) (bar) baz'
  end

  it 'is repeatable'
    SKIP 'Redo buffer is not recorded correctly in a test script.'
    Expect Do('dsib2fb.', '(foo) (bar) (baz)') ==# 'foo (bar) baz'
  end
end

