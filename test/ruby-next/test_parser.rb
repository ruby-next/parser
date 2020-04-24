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

  def test_endless_method
    assert_parses(
      s(:def_e, :foo,
        s(:args),
        s(:int, 42)),
      %q{def foo() = 42},
      %q{~~~ keyword
        |    ~~~ name
        |          ^ assignment
        |~~~~~~~~~~~~~~ expression},
      SINCE_NEXT)

    assert_parses(
      s(:def_e, :inc,
        s(:args, s(:arg, :x)),
        s(:send,
          s(:lvar, :x), :+,
          s(:int, 1))),
      %q{def inc(x) = x + 1},
      %q{~~~ keyword
        |    ~~~ name
        |           ^ assignment
        |~~~~~~~~~~~~~~~~~~ expression},
      SINCE_NEXT)

    assert_parses(
      s(:defs_e, s(:send, nil, :obj), :foo,
        s(:args),
        s(:int, 42)),
      %q{def obj.foo() = 42},
      %q{~~~ keyword
        |       ^ operator
        |        ~~~ name
        |              ^ assignment
        |~~~~~~~~~~~~~~~~~~ expression},
      SINCE_NEXT)

    assert_parses(
      s(:defs_e, s(:send, nil, :obj), :inc,
        s(:args, s(:arg, :x)),
        s(:send,
          s(:lvar, :x), :+,
          s(:int, 1))),
      %q{def obj.inc(x) = x + 1},
      %q{~~~ keyword
        |        ~~~ name
        |       ^ operator
        |               ^ assignment
        |~~~~~~~~~~~~~~~~~~~~~~ expression},
      SINCE_NEXT)

    assert_parses(
      s(:def_e, :foo,
        s(:forward_args),
        s(:send, nil, :bar,
          s(:forwarded_args))),
      %q{def foo(...) = bar(...)},
      %q{~~~ keyword
        |    ~~~ name
        |             ^ assignment
        |~~~~~~~~~~~~~~~~~~~~~~~ expression},
      SINCE_NEXT)
  end

  def test_endless_method_without_brackets
    assert_diagnoses(
      [:error, :unexpected_token, { :token => 'tEQL' }],
      %Q{def foo = 42},
      %q{        ^ location},
      SINCE_NEXT)

    assert_diagnoses(
      [:error, :unexpected_token, { :token => 'tEQL' }],
      %Q{def obj.foo = 42},
      %q{            ^ location},
      SINCE_NEXT)
  end

  def test_method_brackets_expression_bug
    assert_parses(
      s(:def, :foo,
        s(:args),
        s(:array,
          s(:int, 42))),
      %q{def foo() [42] end},
      %q{},
      SINCE_NEXT)
  end
end
