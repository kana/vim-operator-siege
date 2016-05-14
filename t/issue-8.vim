runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

describe 'vim-operator-siege'
  before
    new
    nmap <buffer> ds  <Plug>(operator-siege-delete)
    nmap <buffer> cs  <Plug>(operator-siege-change)
  end

  after
    close!
  end

  describe 'delete'
    it 'works on edge cases #8'
      Expect Do('fads''', '''foo ''bar'' baz''') ==# '''foo bar baz'''
    end
  end

  describe 'change'
    it 'works on edge cases #8'
      Expect Do('facs''"', '''foo ''bar'' baz''') ==# '''foo "bar" baz'''
    end
  end
end

