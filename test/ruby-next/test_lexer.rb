# encoding: ascii-8bit
# frozen_string_literal: true

require 'helper'
require 'complex'

require 'parser/ruby-next/lexer'

class TestLexerNext < Minitest::Test
  def setup_lexer(version)
    @lex = version == "next" ? Parser::Lexer::Next.new(28) : Parser::Lexer.new(version)

    @lex.comments = []
    @lex.diagnostics = Parser::Diagnostic::Engine.new
    @lex.diagnostics.all_errors_are_fatal = true
    # @lex.diagnostics.consumer = lambda { |diag| $stderr.puts "", diag.render }
  end

  def setup
    setup_lexer 18
  end

  def utf(str)
    str.dup.force_encoding(Encoding::UTF_8)
  end

  #
  # Additional matchers
  #

  def refute_scanned(s, *args)
    assert_raises Parser::SyntaxError do
      assert_scanned(s, *args)
    end
  end

  def assert_escape(expected, input)
    source_buffer = Parser::Source::Buffer.new('(assert_escape)')

    source_buffer.source = "\"\\#{input}\"".encode(input.encoding)

    @lex.reset
    @lex.source_buffer = source_buffer

    lex_token, (lex_value, *) = @lex.advance

    lex_value.force_encoding(Encoding::BINARY)

    assert_equal [:tSTRING, expected],
                 [lex_token, lex_value],
                 source_buffer.source
  end

  def refute_escape(input)
    err = assert_raises Parser::SyntaxError do
      @lex.state = :expr_beg
      assert_scanned "%Q[\\#{input}]"
    end
    assert_equal :fatal, err.diagnostic.level
  end

  def assert_lex_fname(name, type, range)
    begin_pos, end_pos = range
    assert_scanned("def #{name} ",
                   :kDEF, 'def', [0, 3],
                   type, name, [begin_pos + 4, end_pos + 4])

    assert_equal :expr_endfn, @lex.state
  end

  def assert_scanned(input, *args)
    source_buffer = Parser::Source::Buffer.new('(assert_scanned)')
    source_buffer.source = input

    @lex.reset(false)
    @lex.source_buffer = source_buffer

    until args.empty? do
      token, value, (begin_pos, end_pos) = args.shift(3)

      lex_token, (lex_value, lex_range) = @lex.advance
      assert lex_token, 'no more tokens'
      assert_operator [lex_token, lex_value], :eql?, [token, value], input
      assert_equal begin_pos, lex_range.begin_pos
      assert_equal end_pos, lex_range.end_pos
    end

    lex_token, (lex_value, *) = @lex.advance
    refute lex_token, "must be empty, but had #{[lex_token, lex_value].inspect}"
  end

  def test_meth_ref
    setup_lexer "next"

    assert_scanned('foo.:bar',
                  :tIDENTIFIER, 'foo', [0, 3],
                  :tMETHREF,   '.:',   [3, 5],
                  :tIDENTIFIER, 'bar', [5, 8])

    assert_scanned('foo .:bar',
                   :tIDENTIFIER, 'foo', [0, 3],
                   :tMETHREF,   '.:',   [4, 6],
                   :tIDENTIFIER, 'bar', [6, 9])
  end

  def test_meth_ref_unary_op
    setup_lexer "next"

    assert_scanned('foo.:+',
                  :tIDENTIFIER, 'foo', [0, 3],
                  :tMETHREF,    '.:',  [3, 5],
                  :tPLUS,       '+',   [5, 6])

    assert_scanned('foo.:-@',
                  :tIDENTIFIER, 'foo', [0, 3],
                  :tMETHREF,    '.:',  [3, 5],
                  :tUMINUS,     '-@',  [5, 7])
  end

  def test_meth_ref_unsupported_newlines
    setup_lexer "next"

    # MRI emits exactly the same sequence of tokens,
    # the error happens later in the parser

    assert_scanned('foo. :+',
                  :tIDENTIFIER, 'foo', [0, 3],
                  :tDOT,        '.',   [3, 4],
                  :tCOLON,      ':',   [5, 6],
                  :tUPLUS,       '+',  [6, 7])

    assert_scanned('foo.: +',
                  :tIDENTIFIER, 'foo', [0, 3],
                  :tDOT,        '.',   [3, 4],
                  :tCOLON,      ':',   [4, 5],
                  :tPLUS,       '+',   [6, 7])
  end

  def test_endless_method
    setup_lexer "next"

    assert_scanned('def foo() = 42',
                    :kDEF, "def", [0, 3],
                    :tIDENTIFIER, "foo", [4, 7],
                    :tLPAREN2, "(", [7, 8],
                    :tRPAREN, ")", [8, 9],
                    :tEQL, "=", [10, 11],
                    :tINTEGER, 42, [12, 14])
  end
end
