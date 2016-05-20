runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

describe 'vim-operator-siege'
  before
    new
  end

  after
    close!
  end

  describe 'add'
    it 'works on edge cases #7'
      Expect Do('f sabB', [
      \   '''(let ((k (an-integer-between 13 19)))',
      \    '  (print "k = " k))',
      \ ]) ==# [
      \   '''{(let ((k (an-integer-between 13 19)))',
      \    '  (print "k = " k))}',
      \ ]
    end
  end
end


