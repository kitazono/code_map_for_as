# rex  cl.rex --stub
# ruby cl.rex.rb  ../test_data/CLSAMPLE.txt

class ClLexer

rule

# コメント
                \/\*           { @state = :COMMENT; return }
  :COMMENT      [^\*]+         { return }
  :COMMENT      \*+[^\*\/\n]+  { return }
  :COMMENT      \*+\/          { @state = nil; return }

# CALL文 
                CALL           { @state = :CALL; return }
  :CALL         \s+?           { return }
  :CALL         PGM\(          { return }
  :CALL         \w+            { [:PGM, [lineno, text]] }
  :CALL         \)             { @state = nil; return }

# 改行、スペース
  \s+?

# 文字、数字、記号
  .

end