runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

describe '<Plug>(operator-siege-change)'
  before
    new
    map <buffer> cs  <Plug>(operator-siege-change)
  end

  after
    close!
  end

  it 'changes decoration characters enclosing target region'
    Expect Do('csibB', '(foo) (bar) (baz)') ==# '{foo} (bar) (baz)'
    Expect Do('fzcsibB', '(foo) (bar) (baz)') ==# '(foo) (bar) {baz}'
  end

  it 'is repeatable'
    SKIP 'Redo buffer is not recorded correctly in a test script.'
    Expect Do('csibB2fb', '{foo} (bar) {baz}') ==# '{foo} (bar) {baz}'
  end
end

