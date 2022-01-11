# encoding: utf-8
# frozen_string_literal: true

require 'helper'
require 'parse_helper'

Parser::Builders::Default.modernize

class TestParser < Minitest::Test
  include ParseHelper

  def parser_for_ruby_version(version)
    parser = super
    parser.diagnostics.all_errors_are_fatal = true

    %w(foo bar baz).each do |metasyntactic_var|
      parser.static_env.declare(metasyntactic_var)
    end

    parser
  end

  SINCE_NEXT = %w(next)

  def test_meth_ref__27
    assert_parses(
      s(:meth_ref, s(:lvar, :foo), :bar),
      %q{foo.:bar},
      %q{   ^^ dot
        |     ~~~ selector
        |~~~~~~~~ expression},
      SINCE_NEXT)

    assert_parses(
      s(:meth_ref, s(:lvar, :foo), :+@),
      %q{foo.:+@},
      %q{   ^^ dot
        |     ~~ selector
        |~~~~~~~ expression},
      SINCE_NEXT)
  end

  def test_meth_ref__before_27
    assert_diagnoses(
      [:error, :unexpected_token, { :token => 'tCOLON' }],
      %q{foo.:bar},
      %q{    ^ location },
      ALL_VERSIONS - SINCE_NEXT)

    assert_diagnoses(
      [:error, :unexpected_token, { :token => 'tCOLON' }],
      %q{foo.:+@},
      %q{    ^ location },
      ALL_VERSIONS - SINCE_NEXT)
  end

  def test_meth_ref_unsupported_newlines
    assert_diagnoses(
      [:error, :unexpected_token, { :token => 'tCOLON' }],
      %Q{foo. :+},
      %q{     ^ location},
      SINCE_NEXT)

    assert_diagnoses(
      [:error, :unexpected_token, { :token => 'tCOLON' }],
      %Q{foo.: +},
      %q{    ^ location},
      SINCE_NEXT)
  end

  def test_ipair
    assert_parses(
      s(:hash, s(:pair, s(:sym, :bar), s(:lvar, :bar))),
      %q{{bar:}},
      %q{^ begin
        |     ^ end
        |~~~~~~ expression},
      SINCE_NEXT)

    assert_parses(
      s(:hash, s(:pair, s(:sym, :x), s(:send, nil, :x))),
      %q{{x:}},
      %q{^ begin
        |   ^ end
        |~~~~ expression},
      SINCE_NEXT)

    assert_parses(
      s(:hash, s(:pair, s(:sym, :bar), s(:lvar, :bar))),
      %q{{bar:,}},
      %q{^ begin
        |      ^ end
        |~~~~~~~ expression},
      SINCE_NEXT)

    assert_parses(
      s(:hash, s(:pair, s(:sym, :bar), s(:lvar, :bar)), s(:pair, s(:sym, :foo), s(:int, 1))),
      %q{{bar:, foo: 1}},
      %q{^ begin
        |             ^ end
        |~~~~~~~~~~~~~~ expression},
      SINCE_NEXT)

    assert_parses(
      s(:hash, s(:pair, s(:sym, :bar), s(:lvar, :bar)), s(:pair, s(:sym, :foo), s(:int, 1)), s(:pair, s(:sym, :x), s(:send, nil, :x))),
      %q{{bar:, foo: 1, x:}},
      %q{},
      SINCE_NEXT)

    assert_parses(
      s(:hash, s(:pair, s(:sym, :bar), s(:lvar, :bar)), s(:pair, s(:sym, :foo), s(:int, 1)), s(:kwsplat, s(:lvar, :baz))),
      %q{{bar:, foo: 1, **baz}},
      %q{},
      SINCE_NEXT)

    assert_parses(
      s(:hash, s(:pair, s(:sym, :bar), s(:lvar, :bar)), s(:pair, s(:sym, :x), s(:str, "y")), s(:pair, s(:sym, :z), s(:send, nil, :z))),
      %q{{bar:, :x => "y", z:}},
      %q{},
      SINCE_NEXT)
  end

  def test_implicit_pair_keyword
    assert_parses(
      s(:send, nil, :foo,
        s(:kwargs, s(:pair, s(:sym, :bar), s(:lvar, :bar)))),
      %q{foo bar:},
      %q{},
      SINCE_NEXT)

    assert_parses(
      s(:send, nil, :foo,
        s(:kwargs, s(:pair, s(:sym, :bar), s(:lvar, :bar)))),
      %q{foo(bar:)},
      %q{},
      SINCE_NEXT)

    assert_parses(
      s(:send, nil, :foo,
        s(:kwargs,
          s(:pair, s(:sym, :bar), s(:lvar, :bar)),
          s(:pair, s(:sym, :foo), s(:int, 1)))),
      %q{foo bar:, foo: 1},
      %q{},
      SINCE_NEXT)

    assert_parses(
      s(:send, nil, :foo,
        s(:kwargs,
          s(:pair, s(:sym, :bar), s(:lvar, :bar)),
          s(:pair, s(:sym, :foo), s(:int, 1)),
          s(:pair, s(:sym, :x), s(:send, nil, :x)))),
      %q{foo(bar:, foo: 1, x:)},
      %q{},
      SINCE_NEXT)

    assert_parses(
      s(:send, nil, :foo,
        s(:kwargs,
          s(:pair, s(:sym, :bar), s(:lvar, :bar)),
          s(:pair, s(:sym, :foo), s(:int, 1)),
          s(:kwsplat, s(:lvar, :baz)))),
      %q{foo bar:, foo: 1, **baz},
      %q{},
      SINCE_NEXT)
  end

  def test_pattern_matching_match_ivars
    assert_parses_pattern_match(
      s(:in_pattern,
        s(:match_as,
          s(:int, 1),
          s(:match_var, s(:ivar, :@a))),
        nil,
        s(:true)),
      %q{in 1 => @a then true},
      %q{   ~~~~~~~ expression (in_pattern.match_as)
        |     ~~ operator (in_pattern.match_as)},
      SINCE_NEXT
    )

    assert_parses_pattern_match(
      s(:in_pattern,
        s(:array_pattern,
          s(:match_var, s(:ivar, :@a)),
          s(:match_var, s(:ivar, :@c))),
        nil,
        s(:true)),
        %q{in @a, @c then true},
       %q{},
       SINCE_NEXT
    )

    assert_parses_pattern_match(
      s(:in_pattern,
        s(:array_pattern,
          s(:match_var, s(:ivar, :@a)),
          s(:match_rest, s(:match_var, s(:ivar, :@b))),
          s(:match_var, s(:ivar, :@c))),
        nil,
        s(:true)),
        %q{in @a, *@b, @c then true},
       %q{},
       SINCE_NEXT
    )

    assert_parses_pattern_match(
      s(:in_pattern,
        s(:const_pattern,
          s(:const, nil, :A),
          s(:array_pattern,
            s(:match_var, s(:ivar, :@i)),
            s(:match_rest, s(:match_var, s(:ivar, :@j))),
            s(:match_var, s(:ivar, :@k)))),
        nil,
        s(:true)),
      %q{in A(@i, *@j, @k) then true},
      %q{},
      SINCE_NEXT
    )

    assert_parses_pattern_match(
      s(:in_pattern,
        s(:hash_pattern,
          s(:pair,
            s(:sym, :a),
            s(:match_var,
              s(:ivar, :@a)))),
        nil,
        s(:true)),
        %q{in a: @a then true},
      %q{},
      SINCE_NEXT
    )
  end

  def test_pattern_matching_match_gvars
    assert_parses_pattern_match(
      s(:in_pattern,
        s(:match_as,
          s(:int, 1),
          s(:match_var, s(:gvar, :$a))),
        nil,
        s(:true)),
      %q{in 1 => $a then true},
      %q{   ~~~~~~~ expression (in_pattern.match_as)
        |     ~~ operator (in_pattern.match_as)},
      SINCE_NEXT
    )

    assert_parses_pattern_match(
      s(:in_pattern,
        s(:const_pattern,
          s(:const, nil, :A),
          s(:array_pattern,
            s(:match_var, s(:gvar, :$i)),
            s(:match_rest, s(:match_var, s(:gvar, :$j))),
            s(:match_var, s(:gvar, :$k)))),
        nil,
        s(:true)),
      %q{in A($i, *$j, $k) then true},
      %q{},
      SINCE_NEXT
    )

    assert_parses_pattern_match(
      s(:in_pattern,
        s(:hash_pattern,
          s(:pair,
            s(:sym, :a),
            s(:match_var,
              s(:gvar, :$b)))),
        nil,
        s(:true)),
        %q{in a: $b then true},
      %q{},
      SINCE_NEXT
    )

    assert_parses_pattern_match(
      s(:in_pattern,
        s(:hash_pattern,
          s(:pair,
            s(:sym, :a),
            s(:int, 1)),
          s(:match_rest,
              s(:match_var, s(:gvar, :$b)))),
        nil,
        s(:true)),
        %q{in {a: 1, **$b} then true},
      %q{},
      SINCE_NEXT
    )
  end
end
