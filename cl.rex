# rex  cl.rex --stub
# ruby cl.rex.rb  ../test_data/CLSAMPLE.txt

class ClLexer

rule

# �R�����g
                \/\*           { @state = :COMMENT; return }
  :COMMENT      [^\*]+         { return }
  :COMMENT      \*+[^\*\/\n]+  { return }
  :COMMENT      \*+\/          { @state = nil; return }

# CALL�� 
                CALL           { @state = :CALL; return }
  :CALL         \s+?           { return }
  :CALL         PGM\(\*\w+\/   { return }
  :CALL         PGM\(&\w+\/    { return }
  :CALL         PGM\(\w+\/     { return }
  :CALL         PGM\(          { return }
  :CALL         \w+            { @state = nil; [:PGM, [lineno, text]] }
#  :CALL         \)             { @state = nil; return }

# ���s�A�X�y�[�X
  \s+?

# �����A�����A�L��
  .

end