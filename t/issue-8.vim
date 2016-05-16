runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

describe 'vim-operator-siege'
  before
    new
  end

  after
    close!
  end

  " MEMO:
  " 'foo 'bar' baz'
  " <----><-><---->
  " a' and i' on the second and third ' do not targt the second block.
  "
  " MEMO:
  " function Rec()
  "   let g:x = getpos('.')
  "   return ''
  " endfunction
  " nmap <expr> rec  Rec()
  " put ='foo bar baz'
  " normal farec
  " ...
  " g:x equals [0, 2, 1, 0], not [0, 2, 6, 0].

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

