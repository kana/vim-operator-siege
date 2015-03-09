runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

describe '<Plug>(siege-change)'
  before
    new
    map <buffer> cs  <Plug>(siege-change)
  end

  after
    close!
  end

  it 'changes decoration characters enclosing target region'
    Expect Do('csbB', '(foo) (bar) (baz)') ==# '{foo} (bar) (baz)'
    Expect Do('fzcsbB', '(foo) (bar) (baz)') ==# '(foo) (bar) {baz}'
  end

  it 'is repeatable'
    SKIP 'Redo buffer is not recorded correctly in a test script.'
    Expect Do('csbB2fb', '{foo} (bar) {baz}') ==# '{foo} (bar) {baz}'
  end
end

