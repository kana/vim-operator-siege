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

  " MEMO:
  " 'foo 'bar' baz'
  " <----><-><---->
  " a' and i' on the second and third ' do not targt the second block.

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

