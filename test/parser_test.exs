defmodule ParserTest do
  use ExUnit.Case, async: true

  test "parses a simple sequent" do
    assert Parser.parse("p->q,p|-q") == [
             %TableauxNode{
               formula: {:implies, :p, :q},
               closed: false,
               source: nil,
               sign: :T,
               nid: 1
             },
             %TableauxNode{
               formula: :p,
               closed: false,
               source: nil,
               sign: :T,
               nid: 2
             },
             %TableauxNode{
               formula: :q,
               closed: false,
               source: nil,
               sign: :F,
               nid: 3
             }
           ]
  end

  test "ignores spaces on input" do
    assert Parser.parse("p -> q,   p|-   q") == Parser.parse("p->q,p|-q")
  end

  test "uses the correct operator precedence" do
    assert Parser.parse("p&q->!r|s|-t") == Parser.parse("(p&q)->((!r)|s)|-t")
  end

  test "parses complex sequents" do
    assert Parser.parse("p&!q->r|t, t->q|!r, r&!q, p|t |- p->!r") == [
             %TableauxNode{
               formula: {:implies, {:and, :p, {:not, :q}}, {:or, :r, :t}},
               closed: false,
               source: nil,
               sign: :T,
               nid: 1
             },
             %TableauxNode{
               formula: {:implies, :t, {:or, :q, {:not, :r}}},
               closed: false,
               source: nil,
               sign: :T,
               nid: 2
             },
             %TableauxNode{
               formula: {:and, :r, {:not, :q}},
               closed: false,
               source: nil,
               sign: :T,
               nid: 3
             },
             %TableauxNode{
               formula: {:or, :p, :t},
               closed: false,
               source: nil,
               sign: :T,
               nid: 4
             },
             %TableauxNode{
               formula: {:implies, :p, {:not, :r}},
               closed: false,
               source: nil,
               sign: :F,
               nid: 5
             }
           ]
  end
end
