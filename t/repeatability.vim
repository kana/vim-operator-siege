runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

describe 'operator-siege'
  before
    new
  end

  after
    close!
  end

  context '<Plug>(operator-siege-add)'
    it 'is repeatable'
      Expect Do('siwb2fb.', 'foo bar baz') ==# '(foo) bar (baz)'
    end
  end

  context '<Plug>(operator-siege-add-with-indent)'
    it 'is repeatable'
      setlocal expandtab shiftwidth=2
      Expect Do('SSBj.', 'foo bar baz') ==# ['{', '  {', '    foo bar baz', '  }', '}']
    end
  end

  context '<Plug>(operator-siege-delete)'
    it 'is repeatable'
      Expect Do('dsb2fb..', '(foo) (bar) (baz)') ==# 'foo (bar) baz'
    end
  end

  context '<Plug>(operator-siege-change)'
    it 'is repeatable'
      Expect Do('csbB2fb.', '(foo) (bar) (baz)') ==# '{foo} (bar) {baz}'
    end
  end
end
