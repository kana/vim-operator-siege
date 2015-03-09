runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

describe '<Plug>(siege-delete)'
  before
    new
    map <buffer> ds  <Plug>(siege-delete)
  end

  after
    close!
  end

  it 'deletes decoration characters enclosing target region'
    Expect Do('dsb', '(foo) (bar) (baz)') ==# 'foo (bar) (baz)'
    Expect Do('fzdsb', '(foo) (bar) (baz)') ==# '(foo) (bar) baz'
  end

  it 'is repeatable'
    SKIP 'Redo buffer is not recorded correctly in a test script.'
    Expect Do('dsb2fb.', '(foo) (bar) (baz)') ==# 'foo (bar) baz'
  end
end

