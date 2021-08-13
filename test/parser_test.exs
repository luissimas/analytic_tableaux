defmodule ParserTest do
  use ExUnit.Case, async: true

  test "parses a simple sequent" do
    assert Parser.parse("p->q,p|-q") == [
             %Formula{
               formula: {:implies, :p, :q},
               sign: :T
             },
             %Formula{
               formula: :p,
               sign: :T
             },
             %Formula{
               formula: :q,
               sign: :F
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
             %Formula{
               formula: {:implies, {:and, :p, {:not, :q}}, {:or, :r, :t}},
               sign: :T
             },
             %Formula{
               formula: {:implies, :t, {:or, :q, {:not, :r}}},
               sign: :T
             },
             %Formula{
               formula: {:and, :r, {:not, :q}},
               sign: :T
             },
             %Formula{
               formula: {:or, :p, :t},
               sign: :T
             },
             %Formula{
               formula: {:implies, :p, {:not, :r}},
               sign: :F
             }
           ]
  end
end
